#!/bin/bash

function prepare_lambda {
    sudo apt-get install unzip
    sudo apt-get install curl
    sudo apt-get -y install nodejs npm

    if [ -d "write-payload-func" ]; then rm -Rf write-payload-func; fi

    curl -L -o write-payload-func.zip https://github.com/TudorIonutElian/write-payload-func/archive/refs/heads/main.zip

    unzip write-payload-func.zip -d write-payload-func

    mv write-payload-func/write-payload-func-main/* write-payload-func/
    rm -r write-payload-func/write-payload-func-main
    rm write-payload-func.zip

    cd write-payload-func
    npm install
}

function terraform_init {
    cd ../
    terraform init
    terraform plan
}