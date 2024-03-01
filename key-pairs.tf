resource "tls_private_key" "privatekey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = "myEc2Key"       # Create a "myKey" to AWS!!
  public_key = tls_private_key.privatekey.public_key_openssh

  provisioner "local-exec" { 
    # Create a "myKey.pem" to your computer!!
    command = "echo '${tls_private_key.privatekey.private_key_pem}' > ./myEc2Key.pem"
  }
}