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


/**
 * This file is used to create a lambda function and attach the role to it.
 * The lambda function is created using the zip file of the lambda function code.
 * The role is created and attached to the lambda function.
 * The role has a policy attached to it which allows the lambda function to access the S3 bucket.
 */

data "archive_file" "get_logs_func_zip" {
  type        = "zip"
  source_dir  = "get-logs-func"
  output_path = "get_logs_func.zip"
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
  source_code_hash = module.get_logs_data_archive.lambda_output_path.output_base64sha256

  environment {
    variables = {
      rds_instance_endpoint = aws_db_instance.custom_cloudwatch_database.address,
      rds_instance_username = var.custom_cloudwatch_database.username,
      rds_instance_password = var.custom_cloudwatch_database.password,
      rds_instance_database_name = var.custom_cloudwatch_database.database_name
    }
  }
}