####################################################
# Add the cloudwatch-lb load balancer resource
####################################################
resource "aws_lb" "cloudwatch_lb" {
  name               = "cloudwatch-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-0868ea57c075e6db1"]
  subnets            = [
    "subnet-02e4231e49c79a44a", 
    "subnet-02a7bf0175832ccfb"
  ]

}

####################################################
# Add the cloudwatch_target_group target group resource
####################################################
resource "aws_lb_target_group" "cloudwatch_target_group" {
  name     = "cloudwatch-target-group"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = "vpc-02297a87c90a5586e"
}

####################################################
# Add the cloudwatch_target_group_attachment target group attachment resource
####################################################
resource "aws_lb_target_group_attachment" "cloudwatch_target_group_attachment" {
  target_group_arn = aws_lb_target_group.cloudwatch_target_group.arn
  target_id        = aws_instance.iris_tf_demo_ec2_instance.id
}

resource "aws_acm_certificate" "learndevtech_com_cert" {
  domain_name       = "cloud-watch.learndevtech.com"
  validation_method = "DNS"

  tags = {
    Environment = "learndevtech"
  }

  lifecycle {
    create_before_destroy = true
  }
}

####################################################
# Add the cloudwatch_listener listener resource
####################################################
resource "aws_lb_listener" "cloudwatch_listener" {
  load_balancer_arn = aws_lb.cloudwatch_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy       = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.learndevtech_com_cert.arn

  default_action {
    target_group_arn = aws_lb_target_group.cloudwatch_target_group.arn
    type             = "forward"
  }
}

