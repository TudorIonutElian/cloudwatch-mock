/**********************************************************
  # Add the API Gatewy
**********************************************************/

resource "aws_api_gateway_rest_api" "cloudwatch_mock_api" {
  name        = "cloudwatch-mock-api"
  description = "CloudWatch Demo Mock"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

/**********************************************************
*** # Add first resource to the cloudwatch_mock_api
**********************************************************/
resource "aws_api_gateway_resource" "demo" {
  rest_api_id = aws_api_gateway_rest_api.cloudwatch_mock_api.id
  parent_id   = aws_api_gateway_rest_api.cloudwatch_mock_api.root_resource_id
  path_part   = "demo"
}


/**********************************************************
*** # Add first gateway METHOD
**********************************************************/
resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.cloudwatch_mock_api.id
  resource_id   = aws_api_gateway_resource.demo.id
  http_method   = "POST"
  authorization = "NONE"
}

/**********************************************************
*** # Add lambda integration
**********************************************************/
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.cloudwatch_mock_api.id
  resource_id             = aws_api_gateway_resource.demo.id
  http_method             = aws_api_gateway_method.proxy.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.write_payload_func.invoke_arn
}

resource "aws_api_gateway_method_response" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.cloudwatch_mock_api.id
  resource_id = aws_api_gateway_resource.demo.id
  http_method = aws_api_gateway_method.proxy.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.cloudwatch_mock_api.id
  resource_id = aws_api_gateway_resource.demo.id
  http_method = aws_api_gateway_method.proxy.http_method
  status_code = aws_api_gateway_method_response.proxy.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.proxy,
    aws_api_gateway_integration.lambda_integration
  ]
}


/**********************************************************
*** # Add lambda integration
**********************************************************/
resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda_integration,
  ]

  rest_api_id = aws_api_gateway_rest_api.cloudwatch_mock_api.id
  stage_name  = "development"
}