/**********************************************************
  # Add the API Gatewy
**********************************************************/

resource "aws_api_gateway_rest_api" "cloudwatch_mock_api" {
  name        = "cloudwatch-mock-api"
  description = "CloudWatch demo_resource Mock"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

/**********************************************************
*** # Add /demo resource to the API Gateway
**********************************************************/
resource "aws_api_gateway_resource" "demo_resource" {
  rest_api_id = aws_api_gateway_rest_api.cloudwatch_mock_api.id
  parent_id   = aws_api_gateway_rest_api.cloudwatch_mock_api.root_resource_id
  path_part   = "demo"
}


/**********************************************************
*** # Add first gateway METHOD - aws_api_gateway_method
**********************************************************/
resource "aws_api_gateway_method" "proxy_aws_api_gateway_method" {
  rest_api_id   = aws_api_gateway_rest_api.cloudwatch_mock_api.id
  resource_id   = aws_api_gateway_resource.demo_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

/**********************************************************
*** # Add lambda integration
**********************************************************/
resource "aws_api_gateway_integration" "lambda_integration_write_payload_func" {
  rest_api_id             = aws_api_gateway_rest_api.cloudwatch_mock_api.id
  resource_id             = aws_api_gateway_resource.demo_resource.id
  http_method             = aws_api_gateway_method.proxy_aws_api_gateway_method.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.write_payload_func.invoke_arn
}

resource "aws_api_gateway_method_response" "proxy_aws_api_gateway_method_response_demo" {
  rest_api_id = aws_api_gateway_rest_api.cloudwatch_mock_api.id
  resource_id = aws_api_gateway_resource.demo_resource.id
  http_method = aws_api_gateway_method.proxy_aws_api_gateway_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.cloudwatch_mock_api.id
  resource_id = aws_api_gateway_resource.demo_resource.id
  http_method = aws_api_gateway_method.proxy_aws_api_gateway_method.http_method
  status_code = aws_api_gateway_method_response.proxy_aws_api_gateway_method_response_demo.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.proxy_aws_api_gateway_method,
    aws_api_gateway_integration.lambda_integration_write_payload_func
  ]
}

/********************************************************** Add logs resource ************************************/

resource "aws_api_gateway_resource" "logs_resource" {
  rest_api_id = aws_api_gateway_rest_api.cloudwatch_mock_api.id
  parent_id   = aws_api_gateway_rest_api.cloudwatch_mock_api.root_resource_id
  path_part   = "logs"
}


/**********************************************************
*** # Add first gateway METHOD - aws_api_gateway_method
**********************************************************/
resource "aws_api_gateway_method" "proxy_aws_api_gateway_method_logs" {
  rest_api_id   = aws_api_gateway_rest_api.cloudwatch_mock_api.id
  resource_id   = aws_api_gateway_resource.logs_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

/**********************************************************
*** # Add lambda integration
**********************************************************/
resource "aws_api_gateway_integration" "lambda_integration_get_logs_func" {
  rest_api_id             = aws_api_gateway_rest_api.cloudwatch_mock_api.id
  resource_id             = aws_api_gateway_resource.logs_resource.id
  http_method             = aws_api_gateway_method.proxy_aws_api_gateway_method_logs.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get_logs_func.invoke_arn
}

resource "aws_api_gateway_method_response" "proxy_aws_api_gateway_method_response_logs" {
  rest_api_id = aws_api_gateway_rest_api.cloudwatch_mock_api.id
  resource_id = aws_api_gateway_resource.logs_resource.id
  http_method = aws_api_gateway_method.proxy_aws_api_gateway_method_logs.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "proxy_2" {
  rest_api_id = aws_api_gateway_rest_api.cloudwatch_mock_api.id
  resource_id = aws_api_gateway_resource.logs_resource.id
  http_method = aws_api_gateway_method.proxy_aws_api_gateway_method_logs.http_method
  status_code = aws_api_gateway_method_response.proxy_aws_api_gateway_method_response_logs.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.proxy_aws_api_gateway_method_logs,
    aws_api_gateway_integration.lambda_integration_get_logs_func
  ]
}


/**********************************************************
*** # Add lambda integration
**********************************************************/
resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda_integration_write_payload_func,
    aws_api_gateway_integration.lambda_integration_get_logs_func
  ]

  rest_api_id = aws_api_gateway_rest_api.cloudwatch_mock_api.id
  stage_name  = "development"
}