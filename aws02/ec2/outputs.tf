output "web_instances" {
  value = aws_instance.web.*.id
}
