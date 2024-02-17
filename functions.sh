#!/bin/bash

function prepare_lambda {
    sudo apt-get install unzip
    sudo apt-get install curl
    sudo apt-get -y install nodejs npm

    curl -L -o example-lambda.zip https://github.com/TudorIonutElian/example-lambda/archive/refs/heads/main.zip

    unzip example-lambda.zip -d example-lambda

    mv example-lambda/example-lambda-main/* example-lambda/
    rm -r example-lambda/example-lambda-main
    rm example-lambda.zip

    cd example-lambda
    npm install
}

function terraform_init {
    terraform init
    terraform plan
}