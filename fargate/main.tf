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
  app_port = var.app_port
  app_port_two=var.app_port_two
}


module "fargate" {
  source = "./fargate"
  app_port = var.app_port
  container_name = var.container_name
  desired_count = var.desired_count
  fargate_cpu = var.fargate_cpu
  fargate_memory = var.fargate_memory
  image_url = var.image_url
  alb_sg_id = module.vpc.alb_sg_id
  ecs_sg_id = module.vpc.ecs_sg_id
  web_subnets = module.vpc.web_subnets
  public_subnets = module.vpc.public_subnets
  vpc_id = module.vpc.vpc_id
  env = var.env
  app_port_two = var.app_port_two
  container_name_two = var.container_name_two
  desired_count_two = var.desired_count_two
  fargate_cpu_two = var.fargate_cpu_two
  fargate_memory_two = var.fargate_memory_two
  image_url_two = var.image_url_two
}