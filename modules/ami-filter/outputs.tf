output "ami_id" {
  value = data.aws_ami.ec2_ami_filter.id
}