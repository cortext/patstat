/**
 * @overview
 * Handles connecting and interacting directly with the database.
 * @author lu1sd4
 */

/**
 * @type {object}
 * @alias module:db/mysql-helper~mysql
 * @description
 * Promise-wrapped MySQL client library
 * @see {@link https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise|Promise - Javascript}
 * @see {@link https://github.com/sidorares/node-mysql2#using-promise-wrapper|mysql2/promise}
 */
const mysql = require('mysql2/promise');

/**
 * @type {object}
 * @alias module:db/mysql-helper~logger
 * @description
 * Reference to the default logger.
 * @see {@link module:logger|logger}
 */
const logger = require('winston');

/**
 * @type {object}
 * @alias module:db/mysql-helper~queries
 * @description
 * SQL query strings relevant to the script, constructed with values specified
 * in the `table` field of the configuration and placeholders to allow the use
 * of prepared statements.
 * @see {@link module:db/queries|db/queries}
 * @see {@link module:index|index}
 */
const queries = require('./queries');

/**
 * @type {object}
 * @alias module:db/mysql-helper~poolConfig
 * @description
 * Settings for the creation of the database connection pool, some are taken
 * from the global configuration and others are left as sensible defaults.
 * @see {@link module:index|index}
 */
const poolConfig = {
  ...global.gConfig.db.connection,
  waitForConnections: true,
  connectionLimit: 20,
  queueLimit: 0,
};

/**
 * @type {Pool}
 * @alias module:db/mysql-helper~pool
 * @description
 * Database connection pool created from the configuration values specified in
 * {@link module:db/mysql-helper~poolConfig|poolConfig}.
 */
const pool = mysql.createPool(poolConfig);


/**
 * @param {string} queryString - SQL query to be executed
 * @param {Array<string>} queryParams - Parameters for the query's placeholders
 * @alias module:db/mysql-helper~runQuery
 * @returns {Promise<Array<object>>} Result of the query
 * @description
 * Executes a sql query with placeholders and values for each one of them,
 * using one of the connections from the {@link module:db/mysql-helper~pool|pool}.  
 * Releases the connection once the result is ready.
 */
async function runQuery(queryString, queryParams) {
  try {
    const conn = await pool.getConnection();
    const result = await conn.execute(queryString, queryParams);
    conn.release();
    return result;
  } catch (e) {
    logger.info(`Error running query ${queryString}`, e);
    logger.info(`Parameters:\n ${queryParams}`);
    throw e;
  }
}


/**
 * @param {number} n - Position of the row we want.
 * @alias module:db/mysql-helper.queryNthRow
 * @returns {Promise<Array<object>>} Result of the query as an array of rows
 * @description
 * Queries the `n`th row of the table specified in the configuration ordered by
 * the id column also specified in the configuration.
 * Returns the result of 
 * {@link module:db/queries.queryNthRow|queries.queryNthRow} when called with
 * `n - 1`.
 */
async function queryNthRow(n) {
  return runQuery(queries.queryNthRow, [n - 1]);
}

/**
 * @param {string} id - Value of the id column of the row to update.
 * @param {string} text - Translated text to add to the row.
 * @alias module:db/mysql-helper.queryUpdateEnglishField
 * @returns {Promise<Array<object>>} Result of the query as an array of rows
 * @description
 * Sets `text` as the new value for the column specified in the configuration,
 * in the row identified by `id`.
 * Returns the result of 
 * {@link module:db/queries.queryUpdateEnglishField|queries.queryUpdateEnglishField}
 * when called with `text` and `id`.
 */
async function queryUpdateEnglishField(id, text) {
  return runQuery(queries.queryUpdateEnglishField, [text, id]);
}

/**
 * @param {string} id Value of the id column of the first row of the batch
 * @alias module:db/mysql-helper.queryBatchForId
 * @returns {Promise<Array<object>>} Result of the query as an array of rows
 * @description
 * Returns the result of 
 * {@link module:db/queries.queryIdOffset|queries.queryIdOffset}
 * when called with `id`. **I. e.** `config.work.batchSize` rows, starting from the
 * `id`th.
 */
async function queryBatchForId(id) {
  return runQuery(queries.queryIdOffset, [id]);
}

/**
 * @alias module:db/mysql-helper.queryCount
 * @returns {Promise<Array<object>>} Result of the query as an array of rows
 * @description
 * Gets the number of rows in the table of interest.  
 * Returns the result of 
 * {@link module:db/queries.queryCount|queries.queryCount}
 */
async function queryCount() {
  return runQuery(queries.queryCount);
}


/**
 * @alias module:db/mysql-helper.closePool
 * @description
 * Ends all the connections opened by the 
 * {@link module:db/mysql-helper~pool|pool}.
 */
function closePool() {
  pool.end();
}

/** 
 * @module db/mysql-helper
 * @requires mysql2/promise
 * @requires winston
 * @requires db/queries
 * @description
 * Module for connecting and executing database queries.  
 * It is the only module that interacts directly with the database.
 */
module.exports = {
  queryNthRow,
  queryBatchForId,
  queryUpdateEnglishField,
  queryCount,
  closePool,
};
