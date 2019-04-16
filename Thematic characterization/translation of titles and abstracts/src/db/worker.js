const logger = require('winston');
const mysql = require('./mysql-helper');

let id = 1;

class Worker {
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

module.exports = Worker;
