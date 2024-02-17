/**
 * This file is used to create a lambda function and attach the role to it.
 * The lambda function is created using the zip file of the lambda function code.
 * The role is created and attached to the lambda function.
 * The role has a policy attached to it which allows the lambda function to access the S3 bucket.
 */
data "archive_file" "lambda_function_zip" {
  type        = "zip"
  source_dir  = "example-lambda"
  output_path = "index.zip"
}

/*******************************************************
 * This resource is used to create the lambda function.
*******************************************************/

resource "aws_lambda_function" "write_payload_func" {
  filename         = "index.zip"
  function_name    = "cloudWatchLambda"
  role             = aws_iam_role.write_payload_func_role.arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  source_code_hash = data.archive_file.lambda_function_zip.output_base64sha256
}