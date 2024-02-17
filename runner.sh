#!/bin/bash

# Import functions.sh from the ./scripts directory
source ./scripts/functions.sh

# Call the prepare_lambda function
prepare_lambda

# Call the terraform_init function
terraform_init

