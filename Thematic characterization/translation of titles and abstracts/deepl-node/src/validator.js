const joi = require('joi');

const {
  texts: textsSchema,
  key: keySchema,
  targetLanguage: targetLanguageSchema,
} = require('./schemas');

function validateFunctionInput(pairs) {
  const errors = [];
  pairs.forEach((pair) => {
    try {
      joi.assert(pair.input, pair.schema);
    } catch (e) {
      errors.push(e);
    }
  });
  return errors;
}

function validateBatchTranslate(inputTexts, targetLanguage, authKey) {
  return validateFunctionInput([
    { input: inputTexts, schema: textsSchema },
    { input: targetLanguage, schema: targetLanguageSchema },
    { input: authKey, schema: keySchema },
  ]);
}

module.exports = {
  validateBatchTranslate,
};
