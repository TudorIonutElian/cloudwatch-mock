/**
 * This file is used to create a lambda function and attach the role to it.
 * The lambda function is created using the zip file of the lambda function code.
 * The role is created and attached to the lambda function.
 * The role has a policy attached to it which allows the lambda function to access the S3 bucket.
 */

data "archive_file" "write_logs_func_zip" {
  type        = "zip"
  source_dir  = "write-logs-func"
  output_path = "write_logs_func.zip"
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
      rds_instance_endpoint = var.database_endpoint,
      rds_instance_username = var.database_username,
      rds_instance_password = var.database_password,
      rds_instance_port = var.database_port
    }
  }

  vpc_config {
      subnet_ids = ["subnet-02e4231e49c79a44a"]
      security_group_ids = ["sg-0868ea57c075e6db1"]
  }
}

data "aws_iam_policy_document" "WriteLogsAWSLambdaTrustPolicy" {
  statement {
    actions    = ["sts:AssumeRole"]
    effect     = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "write_logs_func_role" {
  name               = "write-logs-func-role"
  assume_role_policy = "${data.aws_iam_policy_document.WriteLogsAWSLambdaTrustPolicy.json}"
}

resource "aws_iam_role_policy_attachment" "write_logs_terraform_lambda_policy" {
  role       = "${aws_iam_role.write_logs_func_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

/***********************************************************************
 * This resource is used to DEFINE the policy TO GET AND PUT OBJECTS
 ***********************************************************************/
resource "aws_iam_policy" "write_logs_func_role_s3_handler_policy" {
  name        = "write_payload_func_role_s3_handler_policy"
  path        = "/"
  description = "A policy for getting objects from s3 bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject"
        ],
        Resource = [
          "arn:aws:s3:::${var.cloudwatch_mock_lambda_bucket_name}/*"
        ]
      }
    ]
  })
}

/***********************************************************************
 * This resource is used to ATTACH the policy to the IAM role
 ***********************************************************************/
resource "aws_iam_role_policy_attachment" "write_logs_func_role_s3_get_handler_policy_attachment" {
  role       = aws_iam_role.write_logs_func_role.name
  policy_arn = aws_iam_policy.write_logs_func_role_s3_handler_policy.arn
}