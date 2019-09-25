/**
 * @overview
 * Abstracts translation services and exposes translation functionality.
 * @author lu1sd4
 */

/**
 * @type {object}
 * @alias module:translator~config
 * @description
 * Global config
 * @see {@link module:index|index}
 */
const config = global.gConfig;

/**
 * @type {string}
 * @alias module:translator~translationService
 * @description
 * Name or key for the translation service.  
 * Taken from {@link module:translator~config|config}.
 * @see {@link module:index|index}
 */
const translationService = config.translation.service;

/**
 * @type {object}
 * @alias module:translator~service
 * @description
 * Holds the reference to the translation adapter which is the one that should
 * directly interact with the service API.
 */
let service = {};

/*
 *  Currently supported services:
 *  - deepl
 */
if (translationService === 'deepl') {
  service = require('./adapters/deepl'); // eslint-disable-line global-require
} else {
  throw new Error(`No adapter for ${translationService} as translation service`);
}

/**
 * @module translator
 * @description
 * Module that abstracts translation service into functionalities.  
 * Uses the value of config.translation.service to use one of the adapters.  
 * Adapters should implement the methods exposed by this module.
 */
module.exports = {
  /**
   * @alias module:translator.batchTranslate
   * @param {Array<string>} texts - Array of texts to translate
   * @description
   * Translates an array of texts.
   * @returns {Array<string>} Array of translated texts. Each item is the
   * translation of the item in the same position of the input array.
   */
  batchTranslate: texts => service.batchTranslate(texts),
  singleTranslate: (text, sourceLanguage) => service.singleTranslate(text, sourceLanguage),
};
