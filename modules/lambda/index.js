const AWS = require('aws-sdk');
const sns = new AWS.SNS();

exports.handler = async (event) => {
  const { email, name } = JSON.parse(event.body);

  const params = {
    Subject: "Welcome!",
    Message: `Hi ${name}, welcome to our platform!`,
    TopicArn: process.env.SNS_TOPIC_ARN
  };

  try {
    await sns.publish(params).promise();
    return {
      statusCode: 200,
      body: JSON.stringify({ message: "Welcome email sent!" })
    };
  } catch (err) {
    return {
      statusCode: 500,
      body: JSON.stringify({ error: err.message })
    };
  }
};

