const config = global.gConfig;
const translationService = config.translation.service;

let service = {};

if (translationService === 'deepl') {
  service = require('./adapters/deepl'); // eslint-disable-line global-require
} else {
  throw new Error(`No adapter for ${translationService} as translation service`);
}

module.exports = {
  batchTranslate: service.batchTranslate,
};
