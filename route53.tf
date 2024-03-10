/*****************************************************
 * Data source to get the hosted zone ID
 ****************************************************/
data "aws_route53_zone" "learndevtech" {
  name         = "learndevtech.com"
  private_zone = false
}

/*****************************************************
 * Create a certificate for the domain
 ****************************************************/
resource "aws_acm_certificate" "learndevtech_certificate" {
  domain_name       = "cloud-watch.learndevtech.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

/*****************************************************
 * Validate the certificate
 ****************************************************/
resource "aws_acm_certificate_validation" "certificate_validation" {
  certificate_arn         = aws_acm_certificate.learndevtech_certificate.arn
  validation_record_fqdns = [aws_route53_record.certificate_validation.fqdn]
}

/*****************************************************
 * Create a record for the API Gateway
 ****************************************************/
resource "aws_route53_record" "api_domain_record" {
  name = "api" # The subdomain (api.sumeet.life)
  type = "CNAME"
  ttl  = "300" # TTL in seconds

  records = ["${aws_api_gateway_rest_api.cloudwatch_mock_api.id}.execute-api.eu-central-1.amazonaws.com"]
  zone_id = data.aws_route53_zone.learndevtech.zone_id
  depends_on = [aws_acm_certificate_validation.certificate_validation]
}

/*****************************************************
 * Create a record for the API Gateway
 ****************************************************/
resource "aws_route53_record" "cloudwatch_domain_record" {
  allow_overwrite = true
  zone_id = data.aws_route53_zone.learndevtech.zone_id
  name    = "cloud-watch.learndevtech.com"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.cloudwatch_ec2_instances.public_ip]
  depends_on = [aws_acm_certificate_validation.certificate_validation]
}

/*****************************************************
 * Create a record for each subdomain
 ****************************************************/
resource "aws_route53_record" "subdomain_records" {
  count = length(var.subdomains)

  name    = "${var.subdomains[count.index]}.learndevtech.com"
  type    = "A"
  ttl     = "300"
  zone_id = data.aws_route53_zone.learndevtech.zone_id
  records = [aws_instance.cloudwatch_ec2_instances.public_ip]
  depends_on = [aws_acm_certificate_validation.certificate_validation]
}