/*
  Set the bucket name for the cloudwatch mock lambda
*/
resource "aws_s3_bucket" "cloudwatch_mock_lambda_bucket" {
  bucket = var.cloudwatch_mock_lambda_bucket_name
}


resource "aws_iam_role" "lambda_role_s3" {
  name = "s3-bucket-logs-role"

  assume_role_policy  = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect: "Allow",
        Action: [
            "s3:PutObject"
        ],
        Resource: [
            "arn:aws:s3:::${var.cloudwatch_mock_lambda_bucket_name}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_bucket_logs_role_policy_attachment" {
  role       = aws_iam_role.lambda_role_s3.name
  policy_arn = aws_iam_policy.lambda_role_s3.arn
}
