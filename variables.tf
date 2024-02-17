/*****************************************************
 * This file contains the variables for the S3 bucket
 ****************************************************/
variable "cloudwatch_mock_lambda_bucket_name" {
  description = "Value for the bucket name"
  default     = "cloudwatch-mock-lambda-bucket"
}

variable "custom_cloudwatch_database" {
  description = "Description of my variable"
  type = object({
    username = string
    password = string
    port : number
  })

  default = {
    username = "example_username"
    password = "example_password"
    port : 3306
  }

}
