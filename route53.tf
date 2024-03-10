/*****************************************************
 * Data source to get the hosted zone ID
 ****************************************************/
data "aws_route53_zone" "learndevtech" {
  name         = "learndevtech.com"
  private_zone = false
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
resource "aws_route53_record" "cloudwatch_domain_record" {
  allow_overwrite = true
  zone_id = data.aws_route53_zone.learndevtech.zone_id
  name    = "cloud-watch.learndevtech.com"
  type    = "A"
  ttl     = "300"
  records = ["${aws_lb.cloudwatch_lb.dns_name}"]
}

