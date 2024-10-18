/**********************************************************
  # Configure S3 Backend
**********************************************************/

terraform {
  backend "s3" {
    bucket         = "cloudwatch-mock-lambda-bucket-state"
    key            = "cloudwatch-mock-state.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "cloudwatch-mock-lambda-bucket-state"
  }
}


/* Test*/
