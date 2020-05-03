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

module "ec2"{
  source ="./ec2"
  env = var.env
  az=var.az
  ubuntu_1804_x86_ami_id=var.ubuntu_1804_x86_ami_id
  instance_type = var.instance_type
  #security groups
  bastion_sg_id = module.vpc.bastion_sg_id
  web_sg_id = module.vpc.web_sg_id
  app_sg_id = module.vpc.app_sg_id
  #subnets
  public_subnets = module.vpc.public_subnets
  web_subnets =module.vpc.web_subnets
  app_subnets=module.vpc.app_subnets
  #keypairs
  key_name= var.instance_key  

}

module "alb"{
  source = "./alb"
  env = var.env
  #subnets
  vpc_id = module.vpc.vpc_id
  web_instance_ids = module.ec2.web_instances
  public_subnets = module.vpc.public_subnets
  alb_sg_id = module.vpc.alb_sg_id
}