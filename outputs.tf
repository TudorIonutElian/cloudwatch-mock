output "api_gateway_url" {
    description = "API Gateway URL to access the web page"
    value = "${aws_api_gateway_rest_api.cloudwatch_mock_api.execution_arn}/*/*"
}