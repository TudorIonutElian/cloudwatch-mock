#!/bin/bash

# Import functions.sh from the ./scripts directory
source ./scripts/functions.sh

# Call the initial_setup function
initial_setup

# Call the prepare_lambda function
prepare_lambda_write_payload_function

# Call the prepare_lambda_write_logs_function
prepare_lambda_write_logs_function

# Call the terraform_init function
terraform_init

