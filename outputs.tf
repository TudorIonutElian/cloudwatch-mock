output "api_gateway_url" {
    description = "API Gateway URL to access the web page"
    value = aws_route53_record.api_domain_record.alias[*].name
}