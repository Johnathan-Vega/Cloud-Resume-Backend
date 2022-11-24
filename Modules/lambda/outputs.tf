output "lambda_arn" {
    description = "ARN of visitor counter lambda function"
    value = aws_lambda_function.visitorFunction.arn
}

output "lambda_function_name" {
    description = "Function name of visitor counter lambda function"
    value = aws_lambda_function.visitorFunction.function_name
}