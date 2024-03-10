data "aws_acm_certificate" "learndevtech_com_cert" {
  domain   = "*.learndevtech.com"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}
