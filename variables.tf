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

variable "lambdas_config" {
  description = "List of lambda functions"
  type = list(
    object(
      {
        name = string
        description = string
        runtime = string
        handler = string
        filename = string
      }
    )
  )
  default = [
    {
      name = "write-payload-func"
      description = "Lambda function to write the payload to the S3 bucket"
      runtime = "nodejs18.x"
      handler = "index.handler"
      filename = "write_payload_func.zip"
    },
    {
      name = "write-logs-func"
      description = "Lambda function to write the logs to the RDS instance"
      runtime = "nodejs18.x"
      handler = "index.handler"
      filename = "write_logs_func.zip"
    },
    {
      name = "get-logs-func"
      description = "Lambda function to get the logs from the RDS instance"
      runtime = "nodejs18.x"
      handler = "index.handler"
      filename = "get_logs_func.zip"
    }
  ]
}
