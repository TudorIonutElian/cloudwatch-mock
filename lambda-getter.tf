resource "null_resource" "lambda_jar" {
    triggers = {
        id = 1
    }

    provisioner "local-exec" {
        command = "./lambda-getter.sh"
    }

    provisioner "local-exec" {
        when    = destroy
        command = "rm example-lambda.zip"
    }
}