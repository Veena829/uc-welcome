resource "aws_sns_topic" "welcome_email_topic" {
  name = var.topic_name
}

resource "aws_lambda_permission" "allow_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_arn
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.welcome_email_topic.arn
}

resource "aws_sns_topic_subscription" "lambda_sub" {
  topic_arn = aws_sns_topic.welcome_email_topic.arn
  protocol  = "lambda"
  endpoint  = var.lambda_function_arn
}

output "topic_arn" {
  value = aws_sns_topic.welcome_email_topic.arn
}
