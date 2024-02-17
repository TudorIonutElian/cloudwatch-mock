/****************************************************
 * Output the API Gateway URL to access the web page
 ****************************************************/
output "API_DEMO_PATH_METHOD" {
  description = "API Gateway URL to access the web page"
  value       = "https://${aws_api_gateway_rest_api.cloudwatch_mock_api.id}.execute-api.eu-central-1.amazonaws.com/${aws_api_gateway_deployment.deployment.stage_name}/${aws_api_gateway_resource.root.path_part}"
}