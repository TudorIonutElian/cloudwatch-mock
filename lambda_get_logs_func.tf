module "get_logs_func_iam" {
  source = "./modules/iam"
  lambda_function_iam_role_name = "get-logs-func-role"
}

module "get_logs_data_archive" {
  source = "./modules/data-archive"
  type = "zip"
  source_dir = "get-logs-func"
  output_path = "get_logs_func"
}

/*******************************************************
 * This resource is used to create the lambda function.
*******************************************************/

resource "aws_lambda_function" "get_logs_func" {
  filename         = "get_logs_func.zip"
  function_name    = "get-logs-func"
  role             = module.get_logs_func_iam.lambda_function_iam_role.arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  source_code_hash = module.get_logs_data_archive.lambda_output_path

  environment {
    variables = {
      rds_instance_endpoint = aws_db_instance.custom_cloudwatch_database.address,
      rds_instance_username = var.custom_cloudwatch_database.username,
      rds_instance_password = var.custom_cloudwatch_database.password,
      rds_instance_database_name = var.custom_cloudwatch_database.database_name
    }
  }
}