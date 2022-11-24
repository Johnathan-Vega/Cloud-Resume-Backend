variable "domain" {
    description = "My domain name"
    type = string
}

variable "subdomain" {
    description = "WWW subdomain"
    type = string
}

variable "lambda_arn" {
    description = "ARN of visitor counter lambda function"
    type = string
}

variable "lambda_function_name" {
    description = "Function name of visitor counter lambda function"
    type = string
}