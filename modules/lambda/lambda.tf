data "archive_file" "init" {
  type        = "zip"
  source_file = "${path.module}/counter.py"
  output_path = "${path.module}/counter.zip"
}

resource "aws_iam_role" "lambda_dynamodb_exec" {
  name = "lambda_dynamodb_exec"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_dynamodb_policy"
  role = aws_iam_role.lambda_dynamodb_exec.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid": "LambdatoDynamodb",
        "Effect"   = "Allow",
        "Action": [
                "dynamodb:PutItem",
                "dynamodb:DeleteItem",
                "dynamodb:GetItem",
                "dynamodb:Scan",
                "dynamodb:UpdateItem",
                "dynamodb:UpdateTable"
            ],
        Resource = var.dynamodb_arn
      },
      {
            "Sid": "Cloudwatchlogs",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "dynamodb:ListTables",
                "logs:CreateLogGroup",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
  })
}

resource "aws_lambda_function" "visitorFunction" {
  filename      = "${path.module}/counter.zip"
  function_name = "visitorFunction"
  role          = aws_iam_role.lambda_dynamodb_exec.arn
  handler       = "counter.lambda_handler"
  runtime = "python3.9"
}

resource "aws_cloudwatch_log_group" "lambda_cloudwatch" {
  name = "/aws/lambda/${aws_lambda_function.visitorFunction.function_name}"
  retention_in_days = 14
}