resource "aws_sns_topic" "custom_cloudwatch_sns_topic" {
  name              = "custom-cloudwatch-sns-topic"
}


resource "aws_sns_topic_policy" "policy" {
  arn    = aws_sns_topic.custom_cloudwatch_sns_topic.arn
  policy = <<POLICY
  {
      "Version":"2012-10-17",
      "Statement":[{
          "Effect": "Allow",
          "Principal": {"Service":"s3.amazonaws.com"},
          "Action": "SNS:Publish",
          "Resource":  "${aws_sns_topic.custom_cloudwatch_sns_topic.arn}",
          "Condition":{
              "ArnLike":{"aws:SourceArn":"${aws_s3_bucket.cloudwatch_mock_lambda_bucket.arn}"}
          }
      }]
  }
  POLICY
}