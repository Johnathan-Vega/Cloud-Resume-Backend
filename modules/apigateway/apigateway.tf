resource "aws_apigatewayv2_api" "apigateway" {
  name          = "visitorcountapi"
  protocol_type = "HTTP"
  cors_configuration {
    allow_origins = [var.domain , var.subdomain]
    allow_headers = ["*"]
  }
}

resource "aws_apigatewayv2_stage" "api_stage" {
  api_id = aws_apigatewayv2_api.apigateway.id
  name        = "prod"
  auto_deploy = true
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_cloudwatch.arn
    format = jsonencode({
      sourceIp                = "$context.identity.sourceIp"
      userAgent               = "$context.identity.userAgent"
      httpMethod              = "$context.httpMethod"
      protocol                = "$context.protocol"
      requestTime             = "$context.requestTime"
      requestId               = "$context.requestId"
      responseLatency         = "$context.responseLatency"
      requestPath             = "$context.path"
      status                  = "$context.status"
      integrationErrorMessage = "$context.integrationErrorMessage"
    }
    )
  }
  default_route_settings {
    throttling_burst_limit = 1
    throttling_rate_limit = 1
  }
}

resource "aws_apigatewayv2_integration" "visitor_count" {
  api_id = aws_apigatewayv2_api.apigateway.id
  integration_uri    = var.lambda_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "api_route" {
  api_id = aws_apigatewayv2_api.apigateway.id
  route_key = "GET /visitor/count"
  target    = "integrations/${aws_apigatewayv2_integration.visitor_count.id}"
}

resource "aws_cloudwatch_log_group" "api_cloudwatch" {
  name = "/aws/apigw/${aws_apigatewayv2_api.apigateway.name}"
  retention_in_days = 14
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.apigateway.execution_arn}/*/*"
}