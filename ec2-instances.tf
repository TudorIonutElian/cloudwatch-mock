module "cloudwatch_ec2" {
  source = "./modules/ec2"
  instance_type = "t2.micro"
  key_name = aws_key_pair.kp.key_name
  domain_name = "learndevtech.com"
}