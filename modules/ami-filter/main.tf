/**********************************************************
  # Added data source to filter the ami called iris_tf_demo_ec2_ami_filter
**********************************************************/

data "aws_ami" "ec2_ami_filter" {
  owners = ["amazon"]
  most_recent = true

  filter {
    name = "name"
    values = ["${var.startsWith}-*-${var.endsWith}"]
  }

  filter {
    name = "architecture"
    values = ["${var.architecture}"]
  }
}