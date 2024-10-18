############################################
# This output is used to get the source directory of the lambda function zip file.
############################################

output "lambda_directory" {
  value = data.archive_file.lambda_func_zip.source_dir
}

############################################
# This output is used to get the output path of the lambda function zip file.
############################################
output "lambda_output_path" {
  value = data.archive_file.lambda_func_zip.output_base64sha256
}