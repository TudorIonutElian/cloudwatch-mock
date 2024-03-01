/**********************************************************
  # Add the API Gatewy
**********************************************************/

resource "aws_api_gateway_rest_api" "get_logs_api" {
  name        = "get-logs-api"
  description = "Get Logs API"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

/**********************************************************
*** # Add first resource to the get_logs_api
**********************************************************/
resource "aws_api_gateway_resource" "logs" {
  rest_api_id = aws_api_gateway_rest_api.get_logs_api.id
  parent_id   = aws_api_gateway_rest_api.get_logs_api.root_resource_id
  path_part   = "logs"
}

/**********************************************************
*** # Add first gateway METHOD
**********************************************************/
resource "aws_api_gateway_method" "proxy_logs" {
  rest_api_id   = aws_api_gateway_rest_api.get_logs_api.id
  resource_id   = aws_api_gateway_resource.logs.id
  http_method   = "POST"
  authorization = "NONE"
}

/**********************************************************
*** # Add lambda integration
**********************************************************/
resource "aws_api_gateway_integration" "lambda_integration_logs" {
  rest_api_id             = aws_api_gateway_rest_api.get_logs_api.id
  resource_id             = aws_api_gateway_resource.logs.id
  http_method             = aws_api_gateway_method.proxy_logs.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.write_payload_func.invoke_arn
}

resource "aws_api_gateway_method_response" "proxy_logs" {
  rest_api_id = aws_api_gateway_rest_api.get_logs_api.id
  resource_id = aws_api_gateway_resource.logs.id
  http_method = aws_api_gateway_method.proxy_logs.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "proxy_logs" {
  rest_api_id = aws_api_gateway_rest_api.get_logs_api.id
  resource_id = aws_api_gateway_resource.logs.id
  http_method = aws_api_gateway_method.proxy_logs.http_method
  status_code = aws_api_gateway_method_response.proxy_logs.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.proxy_logs,
    aws_api_gateway_integration.lambda_integration_logs
  ]
}


/**********************************************************
*** # Add lambda integration
**********************************************************/
resource "aws_api_gateway_deployment" "deployment_logs" {
  depends_on = [
    aws_api_gateway_integration.lambda_integration_logs,
  ]

  rest_api_id = aws_api_gateway_rest_api.get_logs_api.id
  stage_name  = "development"
}