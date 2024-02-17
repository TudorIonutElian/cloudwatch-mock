resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role = aws_iam_role.cloudwatch_lambda_role.name
}

/***********************************************************************
 * This resource is used to ATTACH the policy to the IAM role
 ***********************************************************************/
resource "aws_iam_role_policy_attachment" "cloudwatch_lambda_role_s3_handler_policy_attachment" {
  role       = aws_iam_role.cloudwatch_lambda_role.name
  policy_arn = aws_iam_policy.cloudwatch_lambda_role_s3_handler_policy.arn
}