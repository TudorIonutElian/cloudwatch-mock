module "write_payload_func_iam" {
  source = "./modules/iam"
  lambda_function_iam_role_name = "write-payload-func-role"
}

module "write_payload_func_data_archive" {
  source = "./modules/data-archive"
  type = "zip"
  source_dir = "write-payload-func"
  output_path = "write_payload_func"
}

resource "aws_lambda_function" "write_payload_func" {
  filename         = "write_payload_func.zip"
  function_name    = "write-payload-func"
  role             = module.write_payload_func_iam.lambda_function_iam_role.arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  source_code_hash = module.write_payload_func_data_archive.lambda_output_path
}