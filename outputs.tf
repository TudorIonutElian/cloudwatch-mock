output "web_instance_ip" {
    description = "API Gateway URL to access the web page"
    value = aws_route53_record.record.alias[*].name
}