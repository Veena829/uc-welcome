import { SNSClient, PublishCommand } from "@aws-sdk/client-sns";

// Initialize SNS client (no need to pass region/credentials explicitly in Lambda)
const snsClient = new SNSClient({});

export const handler = async (event) => {
  try {
    // Extract email and name from the event body (sent in POST request)
    const { email, name } = JSON.parse(event.body);

    // Construct the SNS message
    const command = new PublishCommand({
      Subject: "Welcome!",
      Message: `Hi ${name}, welcome to our platform!`,
      TopicArn: process.env.SNS_TOPIC_ARN,  // ARN from environment variable in Lambda
    });

    // Send the message to SNS
    await snsClient.send(command);

    // Return a success response
    return {
      statusCode: 200,
      body: JSON.stringify({ message: "Welcome email sent!" }),
    };
  } catch (error) {
    console.error("Error:", error);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: "Failed to send email." }),
    };
  }
};
