/***********************************************************************
 * This resource is used to ATTACH the policy to the IAM role
 ***********************************************************************/
resource "aws_iam_role_policy_attachment" "write_payload_func_role_s3_handler_policy_attachment" {
  role       = module.write_payload_func_iam.lambda_function_iam_role.name
  policy_arn = aws_iam_policy.write_payload_func_role_s3_handler_policy.arn
}

/***********************************************************************
 * This resource is used to ATTACH the policy to the IAM role
 ***********************************************************************/
resource "aws_iam_role_policy_attachment" "write_logs_func_role_s3_handler_policy_attachment" {
  role       = module.write_logs_func_iam.lambda_function_iam_role.name
  policy_arn = aws_iam_policy.write_logs_invoker_sns_topic_policy.arn
}