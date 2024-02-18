resource "aws_sns_topic" "custom_cloudwatch_sns_topic" {
  name = "custom-cloudwatch-sns-topic"
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

/***********************************************************************
 * This resource is used to subscribe a lambda to the SNS topic subscription
 ***********************************************************************/
resource "aws_sns_topic_subscription" "write_logs_sns_subscription" {
  topic_arn = aws_sns_topic.custom_cloudwatch_sns_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.write_logs_func.arn
}

/*
resource "aws_lambda_permission" "sns_invoke_lambda_permission" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.write_logs_func.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.custom_cloudwatch_sns_topic.arn
}
*/