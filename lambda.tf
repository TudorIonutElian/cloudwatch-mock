/**
 * This file is used to create a lambda function and attach the role to it.
 * The lambda function is created using the zip file of the lambda function code.
 * The role is created and attached to the lambda function.
 * The role has a policy attached to it which allows the lambda function to access the S3 bucket.
 */
data "archive_file" "write_payload_func_zip" {
  type        = "zip"
  source_dir  = "write-payload-func"
  output_path = "write_payload_func.zip"
}

data "archive_file" "write_logs_func_zip" {
  type        = "zip"
  source_dir  = "write-logs-func"
  output_path = "write_logs_func.zip"
}

/*******************************************************
 * This resource is used to create the lambda function.
        for writing the payload to the S3 bucket.
*******************************************************/

resource "aws_lambda_function" "write_payload_func" {
  filename         = "write_payload_func.zip"
  function_name    = "cloudWatchLambda"
  role             = aws_iam_role.write_payload_func_role.arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  source_code_hash = data.archive_file.write_payload_func_zip.output_base64sha256
}


/*******************************************************
 * This resource is used to create the lambda function.
*******************************************************/

resource "aws_lambda_function" "write_logs_func" {
  filename         = "write_logs_func.zip"
  function_name    = "write-logs-func"
  role             = aws_iam_role.write_logs_func_role.arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  source_code_hash = data.archive_file.write_logs_func_zip.output_base64sha256

  environment {
    variables = {
      rds_instance_endpoint = aws_db_instance.custom_cloudwatch_database.endpoint
    }
  }
}