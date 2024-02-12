/**********************************************************
  # Add the API Gatewy
**********************************************************/

resource "aws_api_gateway_rest_api" "cloudwatch_mock_api" {
  name = "cloudwatch-mock-api"
  description = "CloudWatch Demo Mock"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

/**********************************************************
*** # Add first resource to the cloudwatch_mock_api
**********************************************************/
resource "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.cloudwatch_mock_api.id
  parent_id = aws_api_gateway_rest_api.cloudwatch_mock_api.root_resource_id
  path_part = "demo"
}

/**********************************************************
*** # Add first gateway METHOD
**********************************************************/
resource "aws_api_gateway_method" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.cloudwatch_mock_api.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = "POST"
  authorization = "NONE"
}

/**********************************************************
*** # Add lambda integration
**********************************************************/
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.cloudwatch_mock_api.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = aws_api_gateway_method.proxy.http_method
  integration_http_method = "POST"
  type = "MOCK"
}

resource "aws_api_gateway_method_response" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.cloudwatch_mock_api.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = aws_api_gateway_method.proxy.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.cloudwatch_mock_api.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = aws_api_gateway_method.proxy.http_method
  status_code = aws_api_gateway_method_response.proxy.status_code

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
    aws_api_gateway_integration.lambda_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.cloudwatch_mock_api.id
  stage_name = "development"
}