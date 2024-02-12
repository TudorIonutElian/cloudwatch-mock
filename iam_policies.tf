resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role = aws_iam_role.cloudwatch_lambda.name
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cloudwatch_lambda.function_name
  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.cloudwatch_mock_api.execution_arn}/*/*/*"
}