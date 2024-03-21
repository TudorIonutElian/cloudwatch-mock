#!/bin/bash

# Import functions.sh from the ./scripts directory
source ./scripts/functions.sh

# Call the initial_setup function
initial_setup

# Call the prepare_lambda function
loadWritePayloadLambda

# Call the prepare_lambda_write_logs_function
loadWriteLogsLambda

# Call the prepare_lambda_get_logs_function
loadGetLogsLambda

# Call the terraform_init function
terraform_init