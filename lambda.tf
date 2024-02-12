data "archive_file" "lambda_function_zip" {
  type = "zip"
  source_dir = "lambda/*"
  output_path = "index.zip"
}

resource "aws_lambda_function" "cloudwatch_lambda" {
  filename = "index.zip"
  function_name = "cloudWatchLambda"
  role = aws_iam_role.cloudwatch_lambda_role.arn
  handler = "index.handler"
  runtime = "nodejs18.x"
  source_code_hash = data.archive_file.lambda_function_zip.output_base64sha256
}

resource "aws_iam_role" "cloudwatch_lambda_role" {
  name = "lambda-role"

  assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [{
            Action = "sts:AssumeRole",
            Effect = "Allow",
            Principal = {
                Service = "lambda.amazonaws.com"
            }
        }]
    })
}