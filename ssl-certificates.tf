resource "aws_acm_certificate" "learndevtech_com_cert" {
  domain_name               = "learndevtech.com"
  subject_alternative_names = ["*.learndevtech.com"]
  validation_method         = "DNS"
  tags                      = { Name = "example-acm-cert-multiple-domains" }

  lifecycle {
    create_before_destroy = true
  }
}