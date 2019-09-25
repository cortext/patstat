const rp = require('request-promise-native');
const Bottleneck = require('bottleneck');
const http = require('http');
const config = require('./config');

const limiter = new Bottleneck({
  maxConcurrent: 5,
  minTime: 200,
});

limiter.on("failed", async (error, jobInfo) => {
  if (jobInfo.retryCount < 5) {
    return 2000;
  }
});

const request = limiter.wrap(rp);

const agent = new http.Agent({
  //keepAlive: true,
  maxSockets: 15,
  //maxFreeSockets: 5,
});

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

async function getSingleTranslation(inputText, targetLanguage, sourceLanguage, authKey) {
  const body = {
    auth_key: authKey,
    text: inputText,
    source_lang: sourceLanguage,
    target_lang: targetLanguage,
  };
  const options = {
    method: 'POST',
    uri: config.deeplUri,
    form: body,
    json: true,
    pool: agent,
  };
  return request(options);
}

module.exports = {
  getBatchTranslation,
  getSingleTranslation,
};
