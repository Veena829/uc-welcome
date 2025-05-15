# SNS Topic Resource
resource "aws_sns_topic" "welcome_email_topic" {
  name = var.topic_name
}

# SNS Topic Subscription
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.welcome_email_topic.arn
  protocol  = "email"  # You can change this to any other protocol (e.g., "http", "https", "lambda", etc.)
  endpoint  = "your-email@example.com"  # Replace with the actual email address you want to subscribe
}

# Output the SNS topic ARN
output "sns_topic_arn" {
  value = aws_sns_topic.welcome_email_topic.arn
}

