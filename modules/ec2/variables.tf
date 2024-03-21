variable "domain_name" {
  description = "The domain name of the website"
  type        = string
}

variable "subdomains" {
  description = "List of subdomains"
  type        = list(string)
  default     = ["api", "cloud-watch"]
}

variable "environment" {
  description = "The environment of the website"
  type        = string
  default     = "dev"
}

variable "key_name" {
  description = "value of the key name"
  type        = string
}

variable "instance_type" {
  description = "The type of the EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "The AMI ID"
  type        = string
}