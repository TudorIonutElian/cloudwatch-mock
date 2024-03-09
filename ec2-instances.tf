/**********************************************************
  # Added data source to filter the ami called iris_tf_demo_ec2_ami_filter
**********************************************************/

data "aws_ami" "iris_tf_demo_ec2_ami_filter" {
  owners = ["amazon"]
  most_recent = true

  filter {
    name = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name = "architecture"
    values = ["x86_64"]
  }
}

/**********************************************************
  # Create Ec2 Instance called iris_tf_demo_ec2_instance
**********************************************************/
resource "aws_instance" "iris_tf_demo_ec2_instance" {
  ami = data.aws_ami.iris_tf_demo_ec2_ami_filter.id
  instance_type   = "t2.micro"
  key_name = aws_key_pair.kp.key_name
  user_data = file("scripts/cloudwatch_entry_script.sh")

  tags = {
    Name = "iris_terraform_demo_ec2_instance"
  }
}