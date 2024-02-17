/********************************************************
***  Set the bucket name for the cloudwatch mock lambda
********************************************************/
resource "aws_s3_bucket" "cloudwatch_mock_lambda_bucket" {
  bucket = var.cloudwatch_mock_lambda_bucket_name
}


resource "aws_s3_bucket_notification" "notif" {
  bucket = aws_s3_bucket.cloudwatch_mock_lambda_bucket.id

  topic {
    topic_arn = aws_sns_topic.custom_cloudwatch_sns_topic.arn

    events = [
      "s3:ObjectCreated:*",
    ]
  }
}