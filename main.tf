terraform {
  backend "s3" {
    bucket = "resumetfstate"
    key = "terraform.tfstate"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.40.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
}

module "acm" {
  source = "./modules/acm"
  domain = var.domain
  subdomain = var.subdomain
}

module "apigateway" {
  source = "./modules/apigateway"
  domain = var.domain
  subdomain = var.subdomain
  lambda_arn = module.lambda.lambda_arn
  lambda_function_name = module.lambda.lambda_function_name
}

module "cloudfront" {
  source = "./modules/cloudfront"
  bucket_regional_domain_name = module.s3.bucket_regional_domain_name
  tlscert_arn = module.acm.tlscert_arn
  domain = var.domain
  subdomain = var.subdomain
}

module "dynamodb" {
  source = "./modules/dynamodb"
}

module "lambda" {
  source = "./modules/lambda"
  dynamodb_arn = module.dynamodb.dynamodb_arn
}

module "route53" {
  source = "./modules/route53"
  cloudfront_domain_name = module.cloudfront.cloudfront_domain_name
  cloudfront_hosted_zone_id = module.cloudfront.cloudfront_hosted_zone_id
  domain = var.domain
  subdomain = var.subdomain
}

module "s3" {
  source = "./modules/s3"
  bucket = var.bucket
  cloudfront_oai_iam_arn = module.cloudfront.cloudfront_oai_iam_arn
}