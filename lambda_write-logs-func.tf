module "get_write_func_iam" {
  source = "./modules/iam"
  lambda_function_iam_role_name = "write-logs-func-role"
}


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
  role             = module.get_write_func_iam.lambda_function_iam_role.arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  source_code_hash = data.archive_file.write_logs_func_zip.output_base64sha256

  environment {
    variables = {
      rds_instance_endpoint = aws_db_instance.custom_cloudwatch_database.address,
      rds_instance_username = var.custom_cloudwatch_database.username,
      rds_instance_password = var.custom_cloudwatch_database.password,
      rds_instance_database_name = var.custom_cloudwatch_database.database_name
    }
  }
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