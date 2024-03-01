resource "aws_api_gateway_rest_api" "api_get_logs" {
  name = "get-logs-api"
  description = "API for getting logs"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "logs" {
  rest_api_id = aws_api_gateway_rest_api.api_get_logs.id
  parent_id = aws_api_gateway_rest_api.api_get_logs.root_resource_id
  path_part = "logs"
}

resource "aws_api_gateway_method" "proxy_method_get_logs" {
  rest_api_id = aws_api_gateway_rest_api.api_get_logs.id
  resource_id = aws_api_gateway_resource.logs.id
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration_logs" {
  rest_api_id = aws_api_gateway_rest_api.api_get_logs.id
  resource_id = aws_api_gateway_resource.logs.id
  http_method = aws_api_gateway_method.proxy_method_get_logs.http_method
  integration_http_method = "POST"
  type = "MOCK"
}

resource "aws_api_gateway_method_response" "proxy_method_response_logs" {
  rest_api_id = aws_api_gateway_rest_api.api_get_logs.id
  resource_id = aws_api_gateway_resource.logs.id
  http_method = aws_api_gateway_method.proxy_method_get_logs.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "proxy_integration_response_logs" {
  rest_api_id = aws_api_gateway_rest_api.api_get_logs.id
  resource_id = aws_api_gateway_resource.logs.id
  http_method = aws_api_gateway_method.proxy_method_response_logs.http_method
  status_code = aws_api_gateway_method_response.proxy_method_response_logs.status_code

  depends_on = [
    aws_api_gateway_method.proxy_method_get_logs,
    aws_api_gateway_integration.lambda_integration
  ]
}