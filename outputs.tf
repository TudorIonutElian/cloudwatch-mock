output "web_instance_ip" {
    description = "API Gateway URL to access the web page"
    value = "http://${aws_route53_record.record.alias[0].name}"
}