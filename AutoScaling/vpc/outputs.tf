output "bastion_sg_id" {
  value = aws_security_group.bastion_sg.id
}

output "vpc_id"{
  value = aws_vpc.tf_vpc.id
}

output "web_sg_id" {
  value = aws_security_group.web_sg.id
}

output "app_sg_id" {
  value = aws_security_group.app_sg.id
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "web_auto_sg_id" {
  value = aws_security_group.web_auto_scale_sg.id
}

output "public_subnets" {
  value = aws_subnet.tf_public_subnet.*.id
}

output "web_subnets" {
  value = aws_subnet.tf_web_subnet.*.id
}

output "app_subnets" {
  value = aws_subnet.tf_app_subnet.*.id
}