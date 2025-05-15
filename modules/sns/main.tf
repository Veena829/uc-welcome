# SNS Topic Resource
resource "aws_sns_topic" "welcome_email_topic" {
  name = var.topic_name
}

# Lambda Function Resource
resource "aws_lambda_function" "welcome_email_lambda" {
  function_name = "welcome_email_lambda"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  filename      = "lambda.zip"
  source_code_hash = filebase64sha256("lambda.zip")

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.welcome_email_topic.arn
    }
  }
}

# Lambda function policy (ensuring the Lambda can publish to SNS)
resource "aws_iam_policy" "lambda_sns_policy" {
  name   = "lambda_sns_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "sns:Publish"
        Resource = aws_sns_topic.welcome_email_topic.arn
      }
    ]
  })
}

# Attach policy to Lambda's execution role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_lambda_function.welcome_email_lambda.role
  policy_arn = aws_iam_policy.lambda_sns_policy.arn
}

# SNS Topic Subscription for Lambda
resource "aws_sns_topic_subscription" "lambda_subscription" {
  topic_arn = aws_sns_topic.welcome_email_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.welcome_email_lambda.arn

  depends_on = [aws_lambda_function.welcome_email_lambda] # Ensure Lambda is created before subscription
}

# Output the SNS Topic ARN and Lambda Function ARN
output "sns_topic_arn" {
  value = aws_sns_topic.welcome_email_topic.arn
}

output "lambda_function_arn" {
  value = aws_lambda_function.welcome_email_lambda.arn
}
