/**
 * @overview
 * Handles querying rows from the table in batches
 * @author lu1sd4
 */

/**
 * @type {object}
 * @alias module:db/worker~logger
 * @description
 * Reference to the default logger.
 * @see {@link module:logger|logger}
 */
const logger = require('winston');

/**
 * @type {object}
 * @alias module:db/worker~mysql
 * @description
 * Helper for several useful database queries.
 * @see {@link db/mysql-helper|mysql-helper}
 */
const mysql = require('./mysql-helper');

/**
 * @type {number}
 * @alias module:db/worker~id
 * @description
 * Counter to give an id to every {@link Worker}
 * instance created
 */
let id = 1;

/**
 * @description
 * Class representing a Worker
 */
class Worker {
  /**
   * @param {number} leftIndex The id of the first row this worker should retrieve
   * @param {number} rightIndex The id of the last row this worker should retrieve
   * @param {number} stepSize How many rows should this worker retrieve per query
   * @param {number} totalRows How many rows should this worker retrieve in total
   * @description
   * Create a worker
   */
  constructor(leftIndex, rightIndex, stepSize, totalRows) {
    this.initialLeftIndex = leftIndex;
    this.leftIndex = leftIndex;
    this.rightIndex = rightIndex;
    this.stepSize = stepSize;
    this.done = false;
    this.totalRows = totalRows;
    this.rowsProcessed = 0;
    this.counter = 0;
    this.id = id;
    id += 1;
  }

  /**
   * @returns {Promise<Array<object>>} Next batch of rows
   * @description
   * Get next batch of rows.  
   * Retrieves the next page of rows from the database, according to the
   * current value of {@link module:db/worker.Worker.leftIndex} and updates it
   * to the index where the next page should start.  
   * If the new value of leftIndex is greater than or equal to the rightIndex,
   * it means the worker went through all the rows it was supposed to read.
   */
  async getRecords() {
    let result = [];
    //  console.log(this.leftIndex + ' + ' + this.stepSize);
    try {
      [result] = await mysql.queryBatchForId(this.leftIndex);
      this.leftIndex = result[result.length - 1].appln_id;
      this.rowsProcessed += result.length;
      if (this.leftIndex >= this.rightIndex || result.length !== this.stepSize) {
        this.done = true;
      }
    } catch (e) {
      logger.info('Error getting records');
      logger.info(e);
    }
    return result;
  }

  /**
   * @typedef {Object} Worker~WorkerStatus
   * @property {string} id - Worker id
   * @property {string} left - Index where this worker started
   * @property {string} right - Index where this worker will stop
   * @property {string} rowsProcessed - Rows this worker has read so far
   * @property {string} totalRows - Approximate number of rows this worker should read
   */

  /**
   * @returns {Worker~WorkerStatus} Current status of the worker
   * @description
   * Summarizes some attributes for reporting in a {@link Worker~WorkerStatus|WorkerStatus} object
   */
  getStatus() {
    return {
      id: this.id,
      left: this.initialLeftIndex,
      right: this.rightIndex,
      rowsProcessed: this.rowsProcessed,
      totalRows: this.totalRows,
    };
  }
}

/** 
 * @module db/worker
 * @requires db/mysql-helper
 * @requires winston
 * @description
 * Module that exposes the Worker class, which retrieves rows in batches from
 * the database from a specific index to another specific index
 */
module.exports = Worker;
