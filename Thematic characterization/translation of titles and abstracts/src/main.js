/**
 * @file
 * Main module of the script.  
 * Sets up and orchestrates calling the translation service, querying and
 * updating the database rows according to the configuration.
 * @author lu1sd4
 */

/**
 * @type {object}
 * @alias module:main~logger
 * @description
 * Reference to the default logger.
 * @see {@link module:logger|logger}
 */
const logger = require('winston');

/**
 * @type {object}
 * @alias module:main~db
 * @description
 * Object for interacting with the database
 * @see {@link module:db|db}
 */
const db = require('./db');

/**
 * @type {object}
 * @alias module:main~translator
 * @description
 * Object for interacting with the translation service
 * @see {@link module:translator|translator}
 */
const translator = require('./translator');

/**
 * @type {object}
 * @alias module:main~reporter
 * @description
 * Object for reporting the work progress in the console
 * @see {@link module:reporter|reporter}
 */
const reporter = require('./reporter');

/**
 * @type {object}
 * @alias module:main~config
 * @description
 * Configuration values taken from the global variable.
 * @see {@link module:index|index}
 */
const config = global.gConfig;

const {
  /**
   * @type {string}
   * @alias module:main~columnToTranslate
   * @description
   * Name of the column whose values we want to translate.  
   * Taken from the {@link module:main~config|config}.
   */
  columnToTranslate,
} = config.db.table;

const {
  /**
   * @type {string}
   * @alias module:main~nConcurrentWorks
   * @description
   * Number of concurrent workers to split the work.
   * Taken from the {@link module:main~config|config}.  
   * **Do not confuse with Node.js Worker Threads.**
   */
  nConcurrentWorks,
  /**
   * @type {string}
   * @alias module:main~batchSize
   * @description
   * Size of batches. Every service call and db query made by each worker will
   * take into account this value.  
   * Taken from the {@link module:main~config|config}.
   */
  batchSize,
} = config.work;

/**
 * @type {string}
 * @alias module:main~nRows
 * @description
 * Total number of rows to translate. This value should be the same as the size
 * of the table we want to translate.
 * These rows will divided so that 
 * {@link module:main~nConcurrentWorks|nConcurrentWorks} tasks are created,
 * each one consisting in the translation of an equal amount of rows.
 */
let nRows = 0;

/**
 * @type {Array<Worker>}
 * @alias module:main~workers
 * @description
 * Array holding references to the workers. These are the
 * ones in charge of querying the database.
 * @see {@link Worker|Worker}
 */
const workers = [];


/**
 * @alias module:main~done
 * @description
 * Closes the database connection so that the program can 
 * exit successfully (if we keep the connection open it 
 * keeps hanging)
 */
function done() {
  db.closeConnection();
}

function mockInputText(record) {
  return `${record.appln_id} ${record[columnToTranslate]}`;
}

/**
 * @param {number} from index from which the worker will start its queries
 * @param {number} to index where the worker should stop querying
 * @param {number} intervalSize number of rows the worker should read
 * @alias module:main~doWork
 * @description
 * Does the fraction of the work consisting on reading, translating and updating
 * the rows with indexes between *from* and *to*, in batches of *batchSize*
 * rows.  
 * Updates to the *batchSize* rows are done concurrently, but the script does
 * not begin working on a batch until the work with the previous batch has
 * finished.  
 * Also registers the corresponding worker with the reporter so that its 
 * progress is printed and updated in the console.  
 * Its completion does not depend on other external updates to the status of the
 * program, thus, several calls to this function can run concurrently. The
 * amount of concurrent calls to this function is determined by 
 * {@link module:main~nConcurrentWorks}.
 * @see {@link module:main~setupWork}
 * @see {@link Worker}
 */
async function doWork(from, to, intervalSize) {
  const dbWorker = new db.Worker(from, to, batchSize, intervalSize);
  workers.push(dbWorker);
  reporter.addWorker(dbWorker);
  /* eslint-disable no-await-in-loop */
  while (!dbWorker.done) {
    const records = await dbWorker.getRecords();
    const translationResults = await translator.batchTranslate(records.map(mockInputText));
    const translatedRecords = records.map((record, index) => (
      {
        id: record.appln_id,
        englishAbstract: translationResults[index],
      }
    ));
    try {
      await Promise.all(
        translatedRecords.map(record => db.updateEnglishField(record.id, record.englishAbstract)),
      );
    } catch (e) {
      logger.info('Error updating fields');
      logger.info(e);
      throw e;
    }
  }
  /* eslint-enable */
}

/**
 * @alias module:main~updateReport
 * @description
 * Updates the output of the reporter with the current status of the workers.
 */
function updateReport() {
  reporter.update(workers);
}

/**
 * @alias module:main~setupWork
 * @description
 * Splits the work in {@link module:main~nConcurrentWorks|nConcurrentWorks},
 * calculating the size of the work intervals and querying the left and right 
 * indexes for them.  
 * Initializes the reporter and starts the sub-works corresponding to the
 * intervals.  
 * Once the work is done, clears the reporter and ends the database connection.  
 * If the work is not completed, fails accordingly and ends the program.
 */
async function setupWork() {
  try {
    logger.info('Counting non-translated records');
    nRows = await db.count();
    logger.info(`Rows: ${nRows}`);
    logger.info(`Works: ${nConcurrentWorks}`);
    const intervalSize = Math.ceil(nRows / nConcurrentWorks);
    logger.info(`Interval size: ${intervalSize}`);
    const intervals = [{
      left: 0,
      right: await db.nthRowIndex(intervalSize),
    }];
    /* eslint-disable no-await-in-loop */
    for (let i = 1; i < nConcurrentWorks - 1; i += 1) {
      const previous = intervals[i - 1];
      const left = previous.right;
      const right = await db.nthRowIndex((i + 1) * intervalSize);
      intervals.push({ left, right });
    }
    /* eslint-enable */
    intervals.push({
      left: intervals[intervals.length - 1].right,
      right: await db.nthRowIndex(nRows) + 1,
    });
    try {
      reporter.init(nRows);
      const report = setInterval(updateReport, 1000);
      await Promise.all(
        intervals.map(int => doWork(int.left, int.right, intervalSize)),
      );
      setTimeout(() => {
        clearInterval(report);
        logger.info('Work done');
      }, 1000);
    } catch (e) {
      logger.info('Could not finish all work');
      logger.info(e);
    }
    done();
  } catch (e) {
    logger.info('Problem getting count');
    logger.info(e);
  }
}

process.on('unhandledRejection', (ex) => {
  throw ex;
});

/**
 * @alias module:main~init
 * @description
 * Initializes the script
 */
function init() {
  setupWork();
}

/**
 * @module main
 * @description
 * Main module of the script. Sets up and runs the translation work.  
 * This module does not expose any members, it is intended to be the main unit
 * of execution and use the other modules.
 * @requires winston
 * @requires db
 * @requires translator
 * @requires reporter
 */
module.exports = init;
