/*********************************
 * IAM Policy for Lambda function
 *********************************/
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.write_payload_func.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.cloudwatch_mock_api.execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "apigw_lambda_logs" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_logs_func.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.cloudwatch_mock_api.execution_arn}/*/*/*"
}


/***********************************************************************
 * This resource is used to DEFINE the policy TO GET AND PUT OBJECTS
 ***********************************************************************/
resource "aws_iam_policy" "write_payload_func_role_s3_handler_policy" {
  name        = "write_payload_func_role_s3_handler_policy_policy"
  path        = "/"
  description = "A policy for Databricks IAM Role"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ],
        Resource = [
          "arn:aws:s3:::${var.cloudwatch_mock_lambda_bucket_name}/*"
        ]
      }
    ]
  })
}

/***********************************************************************
 * This resource is used to DEFINE the policy TO INVOKE BY SNS TOPIC EVENT
 ***********************************************************************/
resource "aws_iam_policy" "write_logs_invoker_sns_topic_policy" {
  name        = "sns_topic_policy"
  path        = "/"
  description = "A policy for invoking Lambda function by SNS topic"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "lambda:InvokeFunction"
        ],
        Resource = [
          aws_lambda_function.write_logs_func.arn
        ],
        Condition = {
          ArnLike = {
            "aws:SourceArn" = "arn:aws:sns:*:*:${aws_sns_topic.custom_cloudwatch_sns_topic.name}"
          }
        }
      }
    ]
  })
}
