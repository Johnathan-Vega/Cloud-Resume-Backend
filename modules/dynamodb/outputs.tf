output "dynamodb_arn" {
    description = "ARN of the DynamoDB table"
    value = aws_dynamodb_table.dynamodbTable.arn
}