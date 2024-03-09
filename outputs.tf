/****************************************************
 * Output the API Gateway URL to access the web page
 ****************************************************/
output "API_DEMO_PATH_METHOD" {
  description = "API Gateway URL to access the web page"
  value       = "https://${aws_api_gateway_rest_api.cloudwatch_mock_api.id}.execute-api.eu-central-1.amazonaws.com/${aws_api_gateway_deployment.deployment.stage_name}/${aws_api_gateway_resource.demo_resource.path_part}"
}

output "API_LOGS_PATH_METHOD" {
  description = "API Gateway URL to access the web page"
  value       = "https://${aws_api_gateway_rest_api.cloudwatch_mock_api.id}.execute-api.eu-central-1.amazonaws.com/${aws_api_gateway_deployment.deployment.stage_name}/${aws_api_gateway_resource.logs_resource.path_part}"
}

/****************************************************
 * Output the RDS instance endpoint
 ****************************************************/
output "rds_instance_endpoint" {
  description = "value of the RDS instance endpoint"
  value       = aws_db_instance.custom_cloudwatch_database.endpoint
}