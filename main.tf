terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0" # Or whatever latest version you want to use
    }
  }

  required_version = ">= 1.0.0" # Optional, depending on your Terraform CLI version
}

provider "aws" {
  region = "us-east-1"
}

module "sns" {
  source              = "./modules/sns"
  topic_name          = "welcome-email-topic"
  lambda_function_arn = module.lambda.lambda_function_arn
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

