module "ami_filter" {
  source = "./modules/ami-filter"
  startsWith = "al2023-ami"
  endsWith = "x86_64"
  architecture = "x86_64"
}