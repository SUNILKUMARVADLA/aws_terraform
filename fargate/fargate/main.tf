module "alb" {
  source = "../alb"
  app_port = var.app_port
  public_subnets = var.public_subnets
  vpc_id = var.vpc_id
  env = var.env
  alb_sg_id = var.alb_sg_id
  app_port_two = var.app_port_two
}


resource "aws_ecs_cluster" "ecs_cluster" {
  name = "demo-cluster"
}


resource "aws_iam_role" "ecs_role" {
  name = "ecs_role"
  assume_role_policy = file("${path.module}/polices/assume-role-policy.json")
}

resource "aws_iam_role_policy" "ecs_role_policy" {
  policy = file("${path.module}/polices/iam-role-policy.json")
  role = aws_iam_role.ecs_role.id
}

data "template_file" "container_def_data" {
  template = file("${path.module}/polices/fargate-container-def.json")
  vars = {
    container_name = var.container_name
    image_url = var.image_url
    container_port = var.app_port
    host_port = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
  }
}

data "template_file" "container_def_data_two" {
  template = file("${path.module}/polices/fargate-container-def-two.json")
  vars = {
    container_name = var.container_name_two
    image_url = var.image_url_two
    container_port = var.app_port_two
    host_port = var.app_port_two
    fargate_cpu    = var.fargate_cpu_two
    fargate_memory = var.fargate_memory_two
  }
}

resource "aws_ecs_task_definition" "ecs_task_def" {
  family                   = "app_nginx"
  execution_role_arn       =  aws_iam_role.ecs_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.container_def_data.rendered
}

resource "aws_ecs_task_definition" "ecs_task_def_two" {
  family                   = "app_tomacat"
  execution_role_arn       =  aws_iam_role.ecs_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu_two
  memory                   = var.fargate_memory_two
  container_definitions    = data.template_file.container_def_data_two.rendered
}


resource "aws_ecs_service" "main" {
  name            = "app-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_def.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [var.ecs_sg_id]
    subnets          = var.web_subnets
  }

  load_balancer {
    target_group_arn = module.alb.target_group_arn
    container_name   = var.container_name
    container_port   = var.app_port
  }

  depends_on = [module.alb.alb_listener, aws_iam_role_policy.ecs_role_policy]
}



resource "aws_ecs_service" "tomcat" {
  name            = "app-service_two"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_def_two.arn
  desired_count   = var.desired_count_two
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [var.ecs_sg_id]
    subnets          = var.web_subnets
  }

  load_balancer {
    target_group_arn = module.alb.target_group_arn_two
    container_name   = var.container_name_two
    container_port   = var.app_port_two
  }

  depends_on = [module.alb.alb_listener_two, aws_iam_role_policy.ecs_role_policy]
}