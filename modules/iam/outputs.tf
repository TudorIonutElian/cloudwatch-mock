output "lambda_function_iam_role" {
    value = {
        name = aws_iam_role.lambda_function_iam_role.name
        arn  = aws_iam_role.lambda_function_iam_role.arn
    }
}