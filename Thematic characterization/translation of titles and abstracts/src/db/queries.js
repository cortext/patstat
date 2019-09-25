/**
 * @overview
 * Constructs and exposes the relevant SQL query strings for this script
 * @author lu1sd4
 */

/**
 * @type {object}
 * @alias module:db/queries~config
 * @description
 * Global config
 * @see {@link module:index|index}
 */
const config = global.gConfig;

const {
  /**
   * @type {string}
   * @alias module:db/queries~name
   * @description
   * Name of the table of interest.  
   * Taken from {@link module:db/queries~config|config}.
   */
  name,
  /**
   * @type {string}
   * @alias module:db/queries~idColumnName
   * @description
   * Name of the column by which we want to sort and identify the rows.  
   * Taken from {@link module:db/queries~config|config}.  
   * **If the table is not indexed by this column, the script will take a
   * VERY LONG time to run**
   */
  idColumnName,
  /**
   * @type {string}
   * @alias module:db/queries~columnToTranslate
   * @description
   * Name of the column with the text that we want to translate.  
   * Taken from {@link module:db/queries~config|config}.
   */
  columnToTranslate,
  /**
   * @type {string}
   * @alias module:db/queries~columnForTranslation
   * @description
   * Name of the column where we want to add the translation.  
   * Taken from {@link module:db/queries~config|config}.
   */
  columnForTranslation,
  sourceLanguageColumn,
} = config.db.table;

const {
  /**
   * @type {string}
   * @alias module:db/queries~batchSize
   * @description
   * Number of rows we want to read, translate and update during one iteration
   * of work.  
   * Taken from {@link module:db/queries~config|config}.
   */
  batchSize,
} = config.work;

/**
 * @type {string}
 * @alias module:db/queries~queryNthRow
 * @description
 * String of a query that gets the nth row, with the table being ordered
 * according to {@link module:db/queries~idColumnName|idColumnName}.
 */
const queryNthRow = `
  select ${idColumnName}
  from ${name}
  order by ${idColumnName} asc
  limit ?, 1;
`;

/**
 * @type {string}
 * @alias module:db/queries~queryIdOffset
 * @description
 * String of a query that gets {@link module:db/queries~batchSize|batchSize}
 * rows starting from the row with the specified index, with the table being 
 * ordered according to {@link module:db/queries~idColumnName|idColumnName}.
 */
const queryIdOffset = `
  select ${idColumnName}, ${columnToTranslate}, ${sourceLanguageColumn}
  from ${name}
  where ${idColumnName} > ?
  order by ${idColumnName} asc
  limit ${batchSize};
`;

/**
 * @type {string}
 * @alias module:db/queries~queryUpdateEnglishField
 * @description
 * String of a query that sets the first placeholder as the value for
 * {@link module:db/queries~columnForTranslation|columnForTranslation}
 * in the row where {@link module:db/queries~idColumnName|idColumnName}'s value
 * equals the second placeholder.
 */
const queryUpdateEnglishField = `
  update ${name}
  set ${columnForTranslation} = ?
  where ${idColumnName} = ?;
`;

/**
 * @type {string}
 * @alias module:db/queries~queryCount
 * @description
 * String of a query that returns the number of rows in the 
 * {@link module:db/queries~name|table of interest}.
 */
const queryCount = `
  select count(${idColumnName}) as count 
  from ${name};
`;

/** 
 * @module db/queries
 * @description
 * Constructs, stores and exposes all of the relevant SQL queries for this
 * script
 */
module.exports = {
  queryNthRow,
  queryIdOffset,
  queryUpdateEnglishField,
  queryCount,
};
