/**
 * @overview
 * A translation adapter for the deepl service
 * @author lu1sd4
 */

/**
 * @type {object}
 * @alias module:translator/adapters/deepl~logger
 * @description
 * Reference to the default logger.
 * @see {@link module:logger|logger}
 */
const logger = require('winston');

/**
 * @type {object}
 * @alias module:translator/adapters/deepl~clArgs
 * @description
 * Parser for command line arguments
 * @see {@link https://www.npmjs.com/package/command-line-args|command-line-args}
 */
const clArgs = require('command-line-args');

/**
 * @type {object}
 * @alias module:translator/adapters/deepl~deepl
 * @description
 * Deepl client library
 */
const deepl = require('../../../deepl-node');

/**
 * @type {string}
 * @alias module:translator/adapters/deepl~targetLanguage
 * @description
 * Code for the translation target language
 */
const targetLanguage = 'EN';

/**
 * @type {object}
 * @alias module:translator/adapters/deepl~clOptionDefinitions
 * @description
 * Definition of command line parameters
 */
const clOptionDefinitions = [
  { name: 'deepl-key', alias: 'k', type: String },
];

/**
 * @type {object}
 * @alias module:translator/adapters/deepl~clOptions
 * @description
 * Values of command line parameters passed to the program
 */
const clOptions = clArgs(clOptionDefinitions);

/**
 * @type {object}
 * @alias module:translator/adapters/deepl~key
 * @description
 * Value of the 'deepl-key' command line parameter. If not present, the API 
 * cannot be used.
 */
const key = clOptions['deepl-key'];

if (!key) {
  logger.error('You must provide a key for deepl');
  process.exit(1);
}

/**
 * @param {Array<string>} texts - Array of texts to translate
 * @alias module:translator/adapters/deepl.batchTranslate
 * @returns {Array<string>}  Array of translated texts. Each item is the
 * translation of the item in the same position of the input array.
 * @description
 * Implementation of {@link module:translator.batchTranslate|translator.batchTranslate}
 * using the deepl client library.
 */
async function batchTranslate(texts) {
  const result = await deepl.batchTranslate(texts, targetLanguage, key);
  try {
    return result.translations.map(translation => translation.text);
  } catch (e) {
    logger.info('Unexpected response from translation service');
    logger.info(e);
    throw e;
  }
}

/**
 * @module translator/adapters/deepl
 * @description
 * Adapter for the deepl service. When using deepl, we must pass the API key via
 * the `deepl-key` command line arg.  
 * ```
 * $ node index --deepl-key=<our_key>
 * ```
 * or
 * 
 * ```
 * $ node index -k <our_key>
 * ```
 */
module.exports = {
  batchTranslate,
};
