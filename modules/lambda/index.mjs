import { SNSClient, PublishCommand } from "@aws-sdk/client-sns";

// Initialize SNS client (no need to pass region/credentials explicitly in Lambda)
const snsClient = new SNSClient({});

export const handler = async (event) => {
  try {
    // Log the event to see its contents
    console.log("Received event:", JSON.stringify(event));

    // Check if the body exists and is not empty
    if (!event.body) {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: "No body in the request" }),
      };
    }

    // Try parsing the event body safely
    let parsedBody;
    try {
      parsedBody = JSON.parse(event.body);
    } catch (error) {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: "Invalid JSON format in the request body" }),
      };
    }

    const { email, name } = parsedBody;

    // Check if both email and name are present in the parsed body
    if (!email || !name) {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: "Both 'email' and 'name' are required in the request" }),
      };
    }

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
