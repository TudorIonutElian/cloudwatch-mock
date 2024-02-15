sudo apt-get install unzip
sudo apt-get install curl
sudo apt-get install nodejs

curl -L -o example-lambda.zip https://github.com/TudorIonutElian/example-lambda/archive/refs/heads/main.zip

unzip example-lambda.zip -d example-lambda

mv example-lambda/example-lambda-main/* example-lambda/
rm -r example-lambda/example-lambda-main
rm example-lambda.zip

cd example-lambda


terraform init
terraform plan