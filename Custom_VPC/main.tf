provider "aws" {
  region = var.region
  profile = var.profile
  version = "~> 2.15.0"
}

module "vpc" {
  source = "./vpc"
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
  env = var.env
  public_cidrs=var.public_cidrs
  az=var.az
  web_cidrs = var.web_cidrs
  app_cidrs = var.app_cidrs
}
