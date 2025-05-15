resource "aws_sns_topic" "welcome_email_topic" {
  name = var.topic_name
}

output "topic_arn" {
  value = aws_sns_topic.welcome_email_topic.arn
}

