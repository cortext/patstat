const joi = require('joi');

const config = require('./config');

const { languages } = config;

const texts = joi.array().items(joi.string()).min(1).max(50).required()
  .error((errors) => {
    errors.forEach((err) => {
      switch (err.type) {
        case 'any.required':
          err.message = 'You must provide texts';
          break;
        case 'array.min':
          err.message = 'Texts cannot be empty';
          break;
        case 'array.max':
          err.message = 'Texts cannot have more than 50 elements';
          break;
        case 'array.includes':
          err.message = 'All texts must be strings';
          break;
        default:
          err.message = 'Check your texts';
          break;
      }
    });
    return errors;
  });

const key = joi.string().required()
  .error((errors) => {
    errors.forEach((err) => {
      if (err.type === 'any.required') {
        err.message = 'You must provide a key for the service';
      }
    });
    return errors;
  });

const targetLanguage = joi.string().required().valid(languages)
  .error((errors) => {
    errors.forEach((err) => {
      if (err.type === 'any.required') {
        err.message = 'You must provide a target language';
      }
    });
    return errors;
  });

module.exports = {
  texts,
  key,
  targetLanguage,
};
