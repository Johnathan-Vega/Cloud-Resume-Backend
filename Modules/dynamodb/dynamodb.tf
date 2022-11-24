resource "aws_dynamodb_table" "dynamodbTable" {
  name           = "visitor_counter"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "ID"

  attribute {
    name = "ID"
    type = "S"
  }

  tags = {
    Environment = "Cloud Resume Prod"
  }
}