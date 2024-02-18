/**
 * This file is used to create a lambda function and attach the role to it.
 * The lambda function is created using the zip file of the lambda function code.
 * The role is created and attached to the lambda function.
 * The role has a policy attached to it which allows the lambda function to access the S3 bucket.
 */

data "archive_file" "get_logs_func_zip" {
  type        = "zip"
  source_dir  = "get-logs-func"
  output_path = "get.zip"
}

/*******************************************************
 * This resource is used to create the lambda function.
*******************************************************/

resource "aws_lambda_function" "get_logs_func" {
  filename         = "get_logs_func.zip"
  function_name    = "get-logs-func"
  role             = aws_iam_role.get_logs_func_role.arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  source_code_hash = data.archive_file.get_logs_func_zip.output_base64sha256

  environment {
    variables = {
      rds_instance_endpoint = aws_db_instance.custom_cloudwatch_database.endpoint
    }
  }
}