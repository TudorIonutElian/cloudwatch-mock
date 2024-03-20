############################################
# Terraform module to create EC2 instances #
############################################

module "cloudwatch_ec2" {
  source        = "./modules/ec2"
  instance_type = "t2.micro"
  key_name      = module.aws_key_pair.key_pair_name
  domain_name   = "learndevtech.com"
  ami_id        = module.ami_filter.ami_id
  count         = 3
}
