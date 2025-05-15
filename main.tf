provider "aws" {
  region = "us-east-1"
}

module "sns" {
  source = "./modules/sns"
}

module "lambda" {
  source        = "./modules/lambda"
  sns_topic_arn = module.sns.topic_arn
}

module "api_gateway" {
  source              = "./modules/api_gateway"
  lambda_function_arn = module.lambda.lambda_function_arn
  region              = var.region
}

