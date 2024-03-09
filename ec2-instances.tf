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
  user_data = <<-EOF
                yum update -y
                yum install -y httpd
                yum install -y git
                yum install -y nodejs 
                yum install -y npm
                systemctl start httpd
                systemctl enable httpd

                echo "export VARNAME=${output.API_LOGS_PATH_METHOD}" >> /etc/environment

                cd /var/www/
                git clone https://github.com/TudorIonutElian/cloudwatch-logs-vue.git
                mv cloudwatch-logs-vue/* .
                rm -r cloudwatch-logs-vue
                npm install
                npm run build
                mv dist/* /var/www/html/
              EOF

  tags = {
    Name = "iris_terraform_demo_ec2_instance"
  }
}