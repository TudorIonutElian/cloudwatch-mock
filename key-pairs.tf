module "aws_key_pair" {
  source = "./modules/key-pair"
  key_pair_name = "myEc2Key"
  key_algorithm = "RSA"
  key_rsa_bits  = 4096
  key_name_output_file = "myEc2Key.pem"  
}