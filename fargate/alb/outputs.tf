

output "target_group_arn" {
  value = aws_lb_target_group.web_lb_target.arn
}

output "alb_listener" {
  value = aws_lb_listener.my-test-alb-listner
}

output "target_group_arn_two" {
  value = aws_lb_target_group.web_lb_two_target.arn
}

output "alb_listener_two" {
 value = aws_lb_listener.my-test-alb-two-listner
}