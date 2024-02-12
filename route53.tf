data "aws_route53_zone" "learndevtech" {
  name = "learndevtech.com"
  private_zone = false
}


resource "aws_route53_record" "api_domain_record" {
  name = "api" # The subdomain (api.sumeet.life)
  type = "CNAME"
  ttl = "300" # TTL in seconds

  records = ["${aws_api_gateway_rest_api.cloudwatch_mock_api.id}.execute-api.eu-central-1.amazonaws.com"]

  zone_id = data.aws_route53_zone.learndevtech.zone_id
}

resource "aws_acm_certificate" "learndevtech_cert" {
  domain_name = "api.learndevtech.com"
  provider = aws.aws_useast1 # needs to be in US East 1 region
  subject_alternative_names = ["api.learndevtech.com"] # Your custom domain
  validation_method = "DNS"
}