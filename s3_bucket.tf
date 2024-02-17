/********************************************************
***  Set the bucket name for the cloudwatch mock lambda
********************************************************/
resource "aws_s3_bucket" "cloudwatch_mock_lambda_bucket" {
  bucket = var.cloudwatch_mock_lambda_bucket_name
}