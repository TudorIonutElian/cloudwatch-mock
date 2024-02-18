/***********************************************************************
 * This resource is used to create the IAM role for the lambda function.
 ***********************************************************************/
resource "aws_iam_role" "write_payload_func_role" {
  name = "write-payload-lambda-role"

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

/***********************************************************************
 * This resource is used to create the IAM role for the lambda function.
 ***********************************************************************/
resource "aws_iam_role" "write_logs_func_role" {
  name = "write-logs-lambda-role"

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

/***********************************************************************
 * This resource is used to create the IAM role for the lambda function.
 ***********************************************************************/
resource "aws_iam_role" "get_logs_func_role" {
  name = "get-logs-lambda-role"

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