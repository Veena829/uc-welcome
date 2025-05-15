variable "topic_name" {
  description = "Name of the SNS topic"
  type        = string
  default     = "welcome-email-topic"
}
variable "lambda_function_arn" {
  description = "ARN of the Lambda function to subscribe"
  type        = string
}
