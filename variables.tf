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
    port : number,
    database_name = string
  })

  default = {
    username = "example_username"
    password = "example_password"
    database_name = "cloudwatch_logs"
    port : 3306
  }
}

############################################
# List of subdomains

variable "subdomains" {
  description = "List of subdomains"
  type = list(string)
  default = ["api", "cloud-watch"]
}
