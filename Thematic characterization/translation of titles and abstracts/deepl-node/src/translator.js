const apiHelper = require('./api-helper');

const validator = require('./validator');

async function batchTranslate(inputTexts, targetLanguage, authKey) {
  const validationErrors = validator.validateBatchTranslate(inputTexts, targetLanguage, authKey);
  if (validationErrors && validationErrors.length > 0) {
    throw new Error(
      `Please correct the following input errors: ${validationErrors.reduce((prev, cur) => `${prev}\n${cur.message}`, '')}`,
    );
  }
  return apiHelper.getBatchTranslation(inputTexts, targetLanguage, authKey);
}

async function singleTranslate(inputText, targetLanguage, sourceLanguage, authKey) {
  const validationErrors = validator.validateSingleTranslate(inputText, targetLanguage, sourceLanguage, authKey);
  if (validationErrors && validationErrors.length > 0) {
    throw new Error(
      `Please correct the following input errors: ${validationErrors.reduce((prev, cur) => `${prev}\n${cur.message}`, '')}`,
    );
  }
  return apiHelper.getSingleTranslation(inputText, targetLanguage, sourceLanguage, authKey);
}

module.exports = {
  batchTranslate,
  singleTranslate,
};
