const logger = require('winston');
const clArgs = require('command-line-args');
const deepl = require('../../../deepl-node');

const targetLanguage = 'EN';

const clOptionDefinitions = [
  { name: 'deepl-key', alias: 'k', type: String },
];

const clOptions = clArgs(clOptionDefinitions);

const key = clOptions['deepl-key'];

if (!key) {
  logger.error('You must provide a key for deepl');
  process.exit(1);
}

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

module.exports = {
  batchTranslate,
};
