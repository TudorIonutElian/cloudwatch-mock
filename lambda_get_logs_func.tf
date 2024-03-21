############################################
# IAM role for lambda function
############################################
module "get_logs_func_iam" {
  source = "./modules/iam"
  lambda_function_iam_role_name = "get-logs-func-role"
}

############################################
# Data archive for lambda function
############################################
module "get_logs_data_archive" {
  source = "./modules/data-archive"
  type = "zip"
  source_dir = "get-logs-func"
  output_path = "get_logs_func"
}

############################################
# Lambda function to get logs from RDS instance
############################################
module "get_logs_func" {
  source = "./modules/lambda"
  lambda_file_name = "get_logs_func.zip"
  lambda_function_name = "get-logs-func"
  lambda_role = module.get_logs_func_iam.lambda_function_iam_role.arn
  lambda_handler = "index.handler"
  lambda_runtime = "nodejs18.x"
  lambda_source_code_hash = module.get_logs_data_archive.lambda_output_path
  lambda_rds_instance_endpoint = aws_db_instance.custom_cloudwatch_database.address
  lambda_rds_instance_username = var.custom_cloudwatch_database.username
  lambda_rds_instance_password = var.custom_cloudwatch_database.password
  lambda_instance_database_name = var.custom_cloudwatch_database.database_name
}