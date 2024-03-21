############################################
# Terraform module to filter AMI based on
# architecture, startsWith, and endsWith
############################################
 #*  Path: modules/ami-filter/main.tf
 #*  This module is used to filter AMI based on architecture, startsWith, and endsWith
 #*  The module takes the following input:
 #*  - startsWith: The prefix of the AMI name
 #*  - endsWith: The suffix of the AMI name
 #*  - architecture: The architecture of the AMI

module "ami_filter" {
  source = "./modules/ami-filter"
  startsWith = "al2023-ami"
  endsWith = "x86_64"
  architecture = "x86_64"
}