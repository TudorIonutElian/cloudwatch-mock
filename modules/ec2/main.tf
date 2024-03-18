/**********************************************************
  # Added data source to filter the ami called iris_tf_demo_ec2_ami_filter
**********************************************************/

data "aws_ami" "ec2_ami_filter" {
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
resource "aws_instance" "cloudwatch_ec2_instances" {
  ami = data.aws_ami.ec2_ami_filter.id
  instance_type   = var.instance_type
  key_name = var.key_name
  user_data = file("scripts/cloudwatch_entry_script.sh")

  tags = {
    Name = "ec2-cloudwatch-instance"
  }
}

resource "aws_acm_certificate" "learndevtech_com_cert" {
  domain_name       = "${var.domain_name}"
  validation_method = "DNS"

  tags = {
    Environment = "${var.environment}"
  }

  lifecycle {
    create_before_destroy = true
  }
}