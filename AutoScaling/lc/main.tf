
locals {
  az = lookup(var.az,var.env)
  key_name = lookup(var.key_name,var.env)
}


resource "aws_key_pair" "instance_kp" {
  key_name = local.key_name
  public_key = file("~/.ssh/${local.key_name}.pub")
}



resource "aws_lb" "web_lb" {
  name               = "${var.env}-web-lb"
  internal           = false
  load_balancer_type = "application"
  subnets = [var.public_subnets[0],var.public_subnets[1]]
  security_groups = [var.alb_sg_id]
  idle_timeout = 60
  enable_cross_zone_load_balancing = true
  
}



## Creating Launch Template
resource "aws_launch_template" "web_launch_template" {
  name_prefix   = "${var.env}-web-launch-template"
  image_id      = lookup(var.ubuntu_1804_x86_ami_id,var.env)
  instance_type = lookup(var.instance_type,var.env)
  instance_initiated_shutdown_behavior = "terminate"
  key_name = local.key_name
  vpc_security_group_ids = [var.web_auto_sg_id]
   user_data = filebase64("${path.module}/scripts/userdata.sh")
}

##Autoscaling group

resource "aws_autoscaling_group" "web_asg" {
  vpc_zone_identifier = [var.web_subnets[0],var.web_subnets[1]]
  desired_capacity   = 4
  max_size           = 6
  min_size           = 2
  launch_template {
    id      = aws_launch_template.web_launch_template.id
    version = "$Latest"
  }
}

resource "aws_lb_target_group" "web_lb_target" {
  name     = "${var.env}-lb-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_autoscaling_attachment" "alb_autoscale" {
  alb_target_group_arn   = aws_lb_target_group.web_lb_target.arn
  autoscaling_group_name = aws_autoscaling_group.web_asg.id
}




resource "aws_lb_listener" "my-test-alb-listner" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_lb_target.arn
  }
}




resource "aws_autoscaling_policy" "web_asp" {
  name                   = "ScaleOut"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
}

resource "aws_cloudwatch_metric_alarm" "web" {
  alarm_name          = "ScaleOut"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.web_asp.arn]
}

output "aws_lb_id" {
  value = aws_lb.web_lb.arn
}
