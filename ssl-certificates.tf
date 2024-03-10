resource "aws_acm_certificate" "learndevtech_com_cert" {
  domain_name               = "learndevtech.com"
  subject_alternative_names = ["*.learndevtech.com"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}