/**
 * @overview Entry point for the script.
 * Loads the configuration from a file into a globally-accessible variable and sets up the logger.
 * @author lu1sd4
 */

/**
  * @type {object}
  * @alias module:index~config
  * @description
  * Configuration object loaded from the file `./config.json`  
  * This file must have the following structure (**not enforced in code** but the script
  * will fail at some point if any of the values is not provided):
  * ```json
  * {
  *   "db": { // database-related parameters
  *     "connection": {
  *       "host": "",
  *       "port": "",
  *       "user": "",
  *       "password": "",
  *       "database": ""
  *     },
  *     "table": {
  *       "name": "", // name of the table for which we need to translate a column
  *       // name of the column by which we want to identify and sort rows
  *       // *if there is no index for this column in the table, this will take a VERY long time to finish
  *       "idColumnName": "",
  *       "columnToTranslate": "", // column that we want to translate
  *       "columnForTranslation": "" // column to store the translation
  *     }
  *   },
  *   "work": {
  *     "batchSize": 20, // size of each batch of texts to send to the translation API
  *     "nConcurrentWorks": 30 // number of concurrent works that will be querying, calling the API and updating the rows
  *   },
  *   "translation": {
  *     "service": "deepl" // name of the translation service (only deepl is supported currently)
  *   }
  * }
  * ```
  */
const config = require('./config.json');

global.gConfig = config;

/** 
 * @module index
 * @requires logger
 * @requires main
 * @description
 * Entry point for the script.  
 * Loads the configuration into a globally-accessible variable and sets up the logger.  
 * This module does not expose any members and is rather an entry point for setup tasks.
 */

require('./src/logger');
require('./src/main')();
