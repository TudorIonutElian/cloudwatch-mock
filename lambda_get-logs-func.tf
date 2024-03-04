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
  role             = aws_iam_role.get_logs_func_role.arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  source_code_hash = data.archive_file.get_logs_func_zip.output_base64sha256

  environment {
    variables = {
      rds_instance_endpoint = aws_db_instance.custom_cloudwatch_database.address,
      rds_instance_username = var.custom_cloudwatch_database.username,
      rds_instance_password = var.custom_cloudwatch_database.password,
      rds_instance_database_name = var.custom_cloudwatch_database.database_name
    }
  }
}

data "aws_iam_policy_document" "GetLogsAWSLambdaTrustPolicy" {
  statement {
    actions    = ["sts:AssumeRole"]
    effect     = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "get_logs_func_role" {
  name               = "get-logs-func-role"
  assume_role_policy = "${data.aws_iam_policy_document.GetLogsAWSLambdaTrustPolicy.json}"
}

resource "aws_iam_role_policy_attachment" "get_logs_terraform_lambda_policy" {
  role       = "${aws_iam_role.get_logs_func_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}