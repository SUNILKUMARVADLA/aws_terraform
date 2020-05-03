

locals {
  az = lookup(var.az,var.env)
  key_name = lookup(var.key_name,var.env)
}


resource "aws_key_pair" "instance_kp" {
  key_name = local.key_name
  public_key = file("~/.ssh/${local.key_name}.pub")
}

resource "aws_instance" "Bastion" {
  ami           = lookup(var.ubuntu_1804_x86_ami_id,var.env)
  instance_type = lookup(var.instance_type,var.env)
  availability_zone = lookup(local.az,0)
  vpc_security_group_ids = [var.bastion_sg_id]
  key_name = aws_key_pair.instance_kp.key_name
  subnet_id =  element(var.public_subnets,0)
  user_data = file("${path.module}/scripts/nginx_server.sh")
  tags = {
    Name = "${var.env}_BastionHost_1"
}
}

resource "aws_instance" "web" {
  count = length(var.web_subnets)
  ami   = lookup(var.ubuntu_1804_x86_ami_id,var.env)
  instance_type = lookup(var.instance_type,var.env)
  availability_zone = lookup(local.az,count.index)
  vpc_security_group_ids = [var.web_sg_id]
  key_name = aws_key_pair.instance_kp.key_name
  subnet_id =  element(var.web_subnets,count.index)
  user_data = file("${path.module}/scripts/nginx_server.sh")
  tags = {
    Name = "${var.env}_Web_${count.index +1}"
}
}

resource "aws_instance" "app" {
  count = length(var.app_subnets)
  ami           = lookup(var.ubuntu_1804_x86_ami_id,var.env)
  instance_type = lookup(var.instance_type,var.env)
  availability_zone = lookup(local.az,count.index)
  vpc_security_group_ids = [var.app_sg_id]
  key_name = aws_key_pair.instance_kp.key_name
  subnet_id =  element(var.app_subnets,count.index)
  user_data = file("${path.module}/scripts/nginx_server.sh")
  tags = {
    Name = "${var.env}_App_${count.index +1}"
}
}