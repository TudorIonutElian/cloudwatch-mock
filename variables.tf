/*****************************************************
 * This file contains the variables for the S3 bucket
 ****************************************************/
variable "cloudwatch_mock_lambda_bucket_name" {
  description = "Value for the bucket name"
  default     = "cloudwatch-mock-lambda-bucket"
}

############################################
# Database endpoint
############################################
variable "database_endpoint" {
  description = "Value for the database endpoint"
  type = string  
}

############################################
# Database name
############################################
variable "database_username" {
  description = "Value for the database USERNAME"
  type = string  
}

############################################
# Database password
############################################
variable "database_password" {
  description = "Value for the database PASSWORD"
  type = string  
}

############################################
# Database port
############################################
variable "database_port" {
  description = "Value for the database PORT"
  type = string  
}

############################################
# List of subdomains

variable "subdomains" {
  description = "List of subdomains"
  type = list(string)
  default = ["api", "cloud-watch"]
}
