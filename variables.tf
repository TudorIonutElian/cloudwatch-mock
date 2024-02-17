/*****************************************************
 * This file contains the variables for the S3 bucket
 ****************************************************/
variable "cloudwatch_mock_lambda_bucket_name" {
  description = "Value for the bucket name"
  default     = "cloudwatch-mock-lambda-bucket"
}