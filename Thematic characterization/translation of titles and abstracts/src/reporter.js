/**
 * @file Prints and updates formatted status messages related to the progress of the tasks
 * @author lu1sd4
 */

const DraftLog = require('draftlog');

DraftLog(console);

/**
 * @type {number}
 * @alias module:reporter~startTime
 * @description
 * Stores the exact moment when the reporter was initialized.
 * This should be just when the work starts.
 */
let startTime = 0;

/**
 * @type {number}
 * @alias module:reporter~totalRows
 * @description
 * The amount of rows to be read.
 * We can have it here because it does not change during the work.
 */
let totalRows = 0;

/**
 * @type {object}
 * @alias module:reporter~logLines
 * @description
 * Keeps track of the lines containing messages that will be updated
 */
const logLines = {
  workers: {},
};


/**
 * @param {string} workerId The id of a worker
 * @returns {string}
 * A string which contains the word 'worker', a space and the worker's
 * id in that order.
 * @alias module:reporter~makeWorkerIdentifier
 * @description
 * Concatenates the word 'worker', a space and the worker's id.
 */
function makeWorkerIdentifier(workerId) {
  return `worker ${workerId}`;
}

/**
 * @param {number} rowsProcessed Number of rows that have been read
 * @returns {string}
 * A string that indicates the overall progress in terms of the rows
 * that have been read and {@link module:reporter~totalRows|totalRows}
 * @alias module:reporter~makeTotalRowsMessage
 * @description
 * Composes a message that indicates the overall progress of the work
 */
function makeTotalRowsMessage(rowsProcessed) {
  return `Total rows: ${rowsProcessed}/${totalRows}`;
}

/**
 * @param {number} minutes Number of minutes elapsed since the script began reading rows
 * @param {number} seconds Number of seconds belonging to the current minute
 * @returns {string} A string that indicates the elapsed time
 * @description
 * Composes a message with the minutes and seconds that the work
 * has been running
 * @alias module:reporter~makeTotalRowsMessage
 */
function makeTimeElapsedMessage(minutes, seconds) {
  return `Time elapsed: ${minutes}m ${seconds}s`;
}

/**
 * @param {number} rowsPerSecond A measure of how many rows are being processed each second
 * @returns {string} A string of the form 'Performance <rows_per_second>/s'
 * @alias module:reporter~makeTotalRowsMessage
 * @description
 * Composes a message with the word 'Performance' and the rows that
 * are being processed each second
 */
function makePerformanceMessage(rowsPerSecond) {
  return `Performance: ${rowsPerSecond}/s`;
}

/**
 * @param {db/Worker~WorkerStatus} status The status of a worker
 * @returns {string} The formatted message describing the worker's progress
 * @description Composes a formatted message to describe the progress of a worker
 * @alias module:reporter~makeWorkerProgressMessage
 */
function makeWorkerProgressMessage(status) {
  const idString = `Work ${status.id}`.padEnd(12);
  const indexes = `[${status.left}-${status.right}]`.padEnd(22);
  const percentage = Math.floor((status.rowsProcessed / status.totalRows) * 100);
  const percentageString = `${percentage}%`.padEnd(6);
  return `${idString} ${indexes} ${percentageString} (${status.rowsProcessed}/~${status.totalRows})`;
}


/**
 * @param {number} totalRows Total number of rows to read
 * @alias module:reporter.init
 * @description
 * Initializes the reporter module, prints the lines for the initial
 * overall values of the report (mostly zeros).
 */
function init(nRows) {
  startTime = process.hrtime();
  totalRows = nRows;
  /* eslint-disable no-console */
  logLines.totalRows = console.draft(makeTotalRowsMessage(0));
  logLines.timeElapsed = console.draft(makeTimeElapsedMessage(0, 0));
  logLines.performance = console.draft(makePerformanceMessage(0));
  /* eslint-enable */
}


/**
 * @param {db/Worker} worker The worker for which a message will be printed and kept track of for updating
 * @alias module:reporter.addWorker
 * @description
 * Adds a key-value pair to {@link module:reporter~logLines|logLines} in which the key
 * is the result of {@link module:reporter~makeWorkerIdentifier|makeWorkerIdentifier}
 * and the value is a function for updating the message that indicates the status of the
 * progress of the worker.
 * The result of {@link module:reporter~makeWorkerProgressMessage|makeWorkerProgressMessage}
 * is printed to console and is easily updatable with the function saved in {@link module:reporter~logLines|logLines}
 * @see {@link https://github.com/ivanseidel/node-draftlog|draftlog}
 */
function addWorker(worker) {
  const workerId = makeWorkerIdentifier(worker);
  const statusMessage = makeWorkerProgressMessage(worker.getStatus());
  /* eslint-disable no-console */
  logLines.workers[workerId] = console.draft(statusMessage);
  /* eslint-enable */
}


/**
 * @param {Array<db/Worker>} workers An array containing the workers
 * @alias module:reporter.update
 * @description
 * Updates the following report messages:
 * - Each worker.
 * - Time elapsed.
 * - Overall progress.
 * - Rows per second (Performance).
 *
 * Using the data received from the workers to update the measurements.
 */
function update(workers) {
  const end = process.hrtime(startTime);
  const minutes = Math.floor(end[0] / 60);
  const seconds = Math.floor(end[0] % 60);
  let totalRowsProcessed = 0;
  workers.forEach((worker) => {
    totalRowsProcessed += worker.rowsProcessed;
    const updateTextFn = logLines.workers[makeWorkerIdentifier(worker)];
    updateTextFn(makeWorkerProgressMessage(worker.getStatus()));
  });
  const rowsPerSecond = Math.round(totalRowsProcessed / end[0]);
  logLines.totalRows(makeTotalRowsMessage(totalRowsProcessed));
  logLines.timeElapsed(makeTimeElapsedMessage(minutes, seconds));
  logLines.performance(makePerformanceMessage(rowsPerSecond));
}

/**
 * @module reporter
 * @description Module for printing and updating status messages about the workers
 * during the execution of the script. It uses {@link https://github.com/ivanseidel/node-draftlog|draftlog} to update the lines printed
 * to the console.
 * @see {@link https://github.com/ivanseidel/node-draftlog|draftlog}
 */
module.exports = {
  addWorker,
  init,
  update,
};
