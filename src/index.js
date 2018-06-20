// App
const config = require('./config.json');

// AWS
const AWS = require('aws-sdk');
const SNS = new AWS.SNS({
  accessKeyId: config.aws.access_key_id,
  secretAccessKey: config.aws.secret_access_key,
  region: config.aws.region
});

/**
 * Log PubSub message.
 *
 * @param {object} e      PubSub message.
 * @param {object} e.data Base64-encoded message data.
 */
function logEvent(e) {
  console.log(`PUB/SUB MESSAGE ${JSON.stringify(e)}`);
  return e;
}

/**
 * Base64-decode PubSub message.
 *
 * @param {object} e      PubSub message.
 * @param {object} e.data Base64-encoded message data.
 */
function decodeEvent(e) {
  return JSON.parse(Buffer.from(e.data, 'base64').toString());
}

/**
 * Verify request contains proper validation token.
 *
 * @param {object} e Slack event object message.
 */
function publishMessage(e, callback) {
  console.log(`MESSAGE ${JSON.stringify(e)}`);
  return SNS.publish({
      Message: e.submission[config.slack.callback_id],
      TopicArn: config.aws.topic_arn
    }, (err, data) => {
      if (err) throw err;
      console.log(`SNS ${JSON.stringify(data)}`);
      callback();
    });
}

/**
 * Triggered from a message on a Cloud Pub/Sub topic.
 *
 * @param {object} event The Cloud Functions event.
 * @param {function} callback The callback function.
 */
exports.consumeEvent = (event, callback) => {
  Promise.resolve(event.data)
    .then(logEvent)
    .then(decodeEvent)
    .then((e) => publishMessage(e, callback))
    .catch((err) => {
      console.error(err);
      callback();
    });
};
