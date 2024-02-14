resource "null_resource" "lambda_jar" {

  provisioner "local-exec" {
    command = "curl -o https://github.com/TudorIonutElian/example-lambda/archive/refs/heads/main.zip lambda.zip"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm lambda.zip"
  }
}