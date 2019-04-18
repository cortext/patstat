const request = require('request-promise-native');
const http = require('http');
const config = require('./config');

const agent = new http.Agent();
agent.maxSockets = 15;

async function getBatchTranslation(inputTexts, targetLanguage, authKey) {
  const body = {
    auth_key: authKey,
    text: inputTexts,
    target_lang: targetLanguage,
  };
  const options = {
    method: 'POST',
    qsStringifyOptions: { arrayFormat: 'repeat' },
    uri: config.deeplUri,
    form: body,
    json: true,
    pool: agent,
  };
  return request(options);
}

module.exports = {
  getBatchTranslation,
};
