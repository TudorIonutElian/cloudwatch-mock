output "public_ip" {
  value = aws_instance.cloudwatch_ec2_instances.public_ip
}