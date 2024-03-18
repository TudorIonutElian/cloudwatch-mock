module "ami_filter" {
  source = "./modules/ami-filter"
  startsWith = "amzn2"
  endsWith = "x86_64"
  architecture = "x86_64"
}