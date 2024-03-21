resource "tls_private_key" "privatekey" {
  algorithm = var.key_algorithm
  rsa_bits  = var.key_rsa_bits
}

resource "aws_key_pair" "kp" {
  key_name   = var.key_pair_name       
  public_key = tls_private_key.privatekey.public_key_openssh

  provisioner "local-exec" { 
    # Create a "myKey.pem" to your computer!!
    command = "echo '${tls_private_key.privatekey.private_key_pem}' > ./${var.key_name_output_file}.pem"
  }
}