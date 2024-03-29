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
 * Create a record for the API Gateway
 ****************************************************/
resource "aws_route53_record" "api_domain_record" {
  name = "api" # The subdomain (api.sumeet.life)
  type = "CNAME"
  ttl  = "300" # TTL in seconds

  records = ["${aws_api_gateway_rest_api.cloudwatch_mock_api.id}.execute-api.eu-central-1.amazonaws.com"]
  zone_id = data.aws_route53_zone.learndevtech.zone_id
}

/*****************************************************
 * Create a record for the API Gateway
 ****************************************************/
resource "aws_route53_record" "cloudwatch_domain_record_development" {
  allow_overwrite = true
  zone_id = data.aws_route53_zone.learndevtech.zone_id
  name    = "development.cloud-watch.learndevtech.com"
  type    = "A"
  ttl     = "300"
  records = [module.cloudwatch_ec2_development.public_ip]
}

/*****************************************************
 * Create a record for the API Gateway
 ****************************************************/
resource "aws_route53_record" "cloudwatch_domain_record_testing" {
  allow_overwrite = true
  zone_id = data.aws_route53_zone.learndevtech.zone_id
  name    = "testing.cloud-watch.learndevtech.com"
  type    = "A"
  ttl     = "300"
  records = [module.cloudwatch_ec2_testing.public_ip]
}

/*****************************************************
 * Create a record for the API Gateway
 ****************************************************/
resource "aws_route53_record" "cloudwatch_domain_record_staging" {
  allow_overwrite = true
  zone_id = data.aws_route53_zone.learndevtech.zone_id
  name    = "staging.cloud-watch.learndevtech.com"
  type    = "A"
  ttl     = "300"
  records = [module.cloudwatch_ec2_staging.public_ip]
}

/*****************************************************
 * Create a record for the API Gateway
 ****************************************************/
resource "aws_route53_record" "cloudwatch_domain_record_production" {
  allow_overwrite = true
  zone_id = data.aws_route53_zone.learndevtech.zone_id
  name    = "production.cloud-watch.learndevtech.com"
  type    = "A"
  ttl     = "300"
  records = [module.cloudwatch_ec2_production.public_ip]
}
