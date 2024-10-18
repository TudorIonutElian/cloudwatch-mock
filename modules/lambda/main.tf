resource "aws_lambda_function" "lambda_function" {
  filename         = var.lambda_file_name
  function_name    = var.lambda_function_name
  role             = var.lambda_role
  handler          = var.lambda_handler
  runtime          = var.lambda_runtime
  source_code_hash = var.lambda_source_code_hash

  environment {
    variables = {
      rds_instance_endpoint = var.lambda_rds_instance_endpoint,
      rds_instance_username = var.lambda_rds_instance_username,
      rds_instance_password = var.lambda_rds_instance_password,
      rds_instance_database_name = var.lambda_instance_database_name
    }
  }
}