/**
 * @overview
 * Handles interactions with the database exposing only high-level methods
 * @author lu1sd4
 */

/**
 * @type {class}
 * @alias module:db~Worker
 * @description
 * Class for handling the batch reading of the table from a specified index to
 * another one.
 * @see {@link db/Worker|worker}
 */
const Worker = require('./worker');

/**
 * @type {object}
 * @alias module:db~mysql
 * @description
 * Helper for several useful database queries.
 * @see {@link db/mysql-helper|mysql-helper}
 */
const mysql = require('./mysql-helper');

/**
 * @type {object}
 * @alias module:db~dbConfig
 * @description
 * Parameters related to the table.  
 * Taken from the config.
 * @see {@link module:index|index}
 */
const dbConfig = global.gConfig.db.table;


/**
 * @returns {number} The number of rows in the table of interest
 * @alias module:db.count
 * @description
 * Gets the number of rows in the table of interest.
 */
async function count() {
  const [rows] = await mysql.queryCount();
  return rows[0].count;
}

/**
 * @param {number} n
 * Position of the row for which we want the value of the id column. 
 * @alias module:db.nthRowIndex
 * @returns The value of the id column of the nth row (rows sorted by the id
 * column).
 * @description
 * Gets the value of the nth row's id column (specified in config). 
 */
async function nthRowIndex(n) {
  const [rows] = await mysql.queryNthRow(n);
  return rows[0][dbConfig.idColumnName];
}

/** 
 * @module db
 * @requires db/worker
 * @requires db/mysql-helper
 * @description
 * Module that exposes database-related functionality.
 */
module.exports = {
  Worker,
  count,
  nthRowIndex,
  /**
   * @alias module:db.closeConnection
   * @description
   * Ends the connection with the database.
   * @see {@link module:db/mysql-helper.closePool}
   */
  closeConnection: mysql.closePool,
  /**
   * @param {string} id - Id of the row we want to update with its translation
   * @param {string} text - Translated text to add to the row
   * @alias module:db.updateEnglishField
   * @description
   * Updates the row identified by *id*, setting *text* as the new value for the 
   * field specified as `db.table.columnForTranslation` in the configuration.
   * @see {@link module:db/mysql-helper.queryUpdateEnglishField}
   */
  updateEnglishField: mysql.queryUpdateEnglishField,
};
