#!/bin/bash

function initial_setup {
    sudo apt-get install unzip
    sudo apt-get install curl
    sudo apt-get -y install nodejs npm
}

function loadWritePayloadLambda {

    if [ -d "write-payload-func" ]; then rm -Rf write-payload-func; fi

    curl -L -o write-payload-func.zip https://github.com/TudorIonutElian/write-payload-func/archive/refs/heads/main.zip

    unzip write-payload-func.zip -d write-payload-func

    mv write-payload-func/write-payload-func-main/* write-payload-func/
    rm -r write-payload-func/write-payload-func-main
    rm write-payload-func.zip

    cd write-payload-func
    npm install
    cd ../
}

function loadWriteLogsLambda {
    if [ -d "write-logs-func" ]; then rm -Rf write-logs-func; fi

    curl -L -o write-logs-func.zip https://github.com/TudorIonutElian/write-logs-func/archive/refs/heads/main.zip

    unzip write-logs-func.zip -d write-logs-func

    mv write-logs-func/write-logs-func-main/* write-logs-func/
    rm -r write-logs-func/write-logs-func-main
    rm write-logs-func.zip

    cd write-logs-func
    npm install
    cd ../
}

function loadGegLogsLambda {
    if [ -d "get-logs-func" ]; then rm -Rf get-logs-func; fi

    curl -L -o get-logs-func.zip https://github.com/TudorIonutElian/get-logs-func/archive/refs/heads/main.zip

    unzip get-logs-func.zip -d get-logs-func

    mv get-logs-func/get-logs-func-main/* get-logs-func/
    rm -r get-logs-func/get-logs-func-main
    rm get-logs-func.zip

    cd get-logs-func
    npm install
    cd ../
}

function terraform_init {
    terraform init
    terraform plan
}