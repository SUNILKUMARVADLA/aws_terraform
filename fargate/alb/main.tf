
locals{
    count = length(var.public_subnets)
}

resource "aws_lb" "web_lb" {
  name               = "${var.env}-ecs-lb"
  internal           = false
  load_balancer_type = "application"
  subnets = [var.public_subnets[0],var.public_subnets[1]]
  security_groups = [var.alb_sg_id]
}

resource "aws_lb_target_group" "web_lb_target" {
  name     = "${var.env}--ecs-lb-target"
  port     = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = var.vpc_id
 # depends_on = [ aws_lb.web_lb]
  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
}

resource "aws_lb_target_group" "web_lb_two_target" {
  name     = "${var.env}--ecs-lb-two-target"
  port     = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    port   = "3000"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
}


resource "aws_lb_listener" "my-test-alb-two-listner" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = var.app_port_two
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_lb_two_target.arn
  }
}


resource "aws_lb_listener" "my-test-alb-listner" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = var.app_port
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_lb_target.arn
  }
}

resource "aws_lb_listener_rule" "static" {
  listener_arn = aws_lb_listener.my-test-alb-listner.arn
  condition {
    field  = "path-pattern"
    values = ["/block/"]
  }
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_lb_target.arn
  }
}