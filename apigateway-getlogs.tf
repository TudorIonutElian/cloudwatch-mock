/**********************************************************
  # Add the API Gatewy
**********************************************************/

resource "aws_api_gateway_rest_api" "cloudwatch_mock_api_2" {
  name        = "cloudwatch-mock-api"
  description = "CloudWatch Demo Mock"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

/**********************************************************
*** # Add first resource to the cloudwatch_mock_api
**********************************************************/
resource "aws_api_gateway_resource" "logs" {
  rest_api_id = aws_api_gateway_rest_api.cloudwatch_mock_api_2.id
  parent_id   = aws_api_gateway_rest_api.cloudwatch_mock_api_2.root_resource_id
  path_part   = "logs"
}

/**********************************************************
*** # Add first gateway METHOD
**********************************************************/
resource "aws_api_gateway_method" "proxy_2" {
  rest_api_id   = aws_api_gateway_rest_api.cloudwatch_mock_api_2.id
  resource_id   = aws_api_gateway_resource.logs.id
  http_method   = "GET"
  authorization = "NONE"
}

/**********************************************************
*** # Add lambda integration
**********************************************************/
resource "aws_api_gateway_integration" "lambda_integration_2" {
  rest_api_id             = aws_api_gateway_rest_api.cloudwatch_mock_api_2.id
  resource_id             = aws_api_gateway_resource.logs.id
  http_method             = aws_api_gateway_method.proxy_2.http_method
  integration_http_method = "GET"
  type                    = "AWS"
  uri                     = aws_lambda_function.get_logs_func.invoke_arn
}

resource "aws_api_gateway_method_response" "proxy_3" {
  rest_api_id = aws_api_gateway_rest_api.cloudwatch_mock_api_2.id
  resource_id = aws_api_gateway_resource.logs.id
  http_method = aws_api_gateway_method.proxy_2.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "proxy_4" {
  rest_api_id = aws_api_gateway_rest_api.cloudwatch_mock_api_2.id
  resource_id = aws_api_gateway_resource.logs.id
  http_method = aws_api_gateway_method.proxy_2.http_method
  status_code = aws_api_gateway_method_response.proxy_3.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.proxy_2,
    aws_api_gateway_integration.lambda_integration_2
  ]
}


/**********************************************************
*** # Add lambda integration
**********************************************************/
resource "aws_api_gateway_deployment" "deployment_2" {
  depends_on = [
    aws_api_gateway_integration.lambda_integration_2,
  ]

  rest_api_id = aws_api_gateway_rest_api.cloudwatch_mock_api_2.id
  stage_name  = "development"
}