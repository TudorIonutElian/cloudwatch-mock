/***********************************************************************
 * This resource is used to create the IAM role for the lambda function.
 ***********************************************************************/
resource "aws_iam_role" "cloudwatch_lambda_role" {
  name = "lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}