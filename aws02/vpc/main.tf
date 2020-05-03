resource "aws_vpc" "tf_vpc" {
  cidr_block           = lookup(var.vpc_cidr,var.env)
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = lookup(var.vpc_name,var.env)
  }
}

locals{
    public_cidrs = lookup(var.public_cidrs,var.env)
    az = lookup(var.az,var.env)
    web_cidrs = lookup(var.web_cidrs,var.env)
    app_cidrs = lookup(var.app_cidrs,var.env)
    
}

resource "aws_eip" "tf_eip" {
  count = 2
  vpc = true
}

resource "aws_internet_gateway" "tf_internet_gateway" {
  vpc_id = aws_vpc.tf_vpc.id
  tags = {
    Name = "${var.env}_tf_igw"
  }
}

resource "aws_nat_gateway" "tf_nat_gateway" {
  count = length(local.public_cidrs)
  allocation_id = aws_eip.tf_eip.*.id[count.index]
  subnet_id     = aws_subnet.tf_public_subnet.*.id[count.index]
  tags = {
    Name = "${var.env}_tf_ngw_${count.index+1}"
  }
}

resource "aws_subnet" "tf_public_subnet" {
  vpc_id     = aws_vpc.tf_vpc.id
  count     = length(local.public_cidrs)
  cidr_block = local.public_cidrs[count.index]
  availability_zone = lookup(local.az,count.index)
  map_public_ip_on_launch= true
  tags = {
    Name = "${var.env}_tf_public${count.index+1}"
  }
}

resource "aws_subnet" "tf_web_subnet" {
  count     = length(local.web_cidrs)
  vpc_id     = aws_vpc.tf_vpc.id
  cidr_block = local.web_cidrs[count.index]
  availability_zone = lookup(local.az,count.index % 2)
  tags = {
    Name = "${var.env}_tf_web_subnet${count.index+1}"
  }
}

resource "aws_subnet" "tf_app_subnet" {
  count     = length(local.app_cidrs)
  vpc_id     = aws_vpc.tf_vpc.id
  cidr_block = local.app_cidrs[count.index]
  availability_zone = lookup(local.az,count.index % 2)
  tags = {
    Name = "${var.env}_tf_web_subnet${count.index+1}"
  }
}

resource "aws_route_table" "tf_public_rt" {
  vpc_id = aws_vpc.tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_internet_gateway.id
  }
  tags = {
    Name = "${var.env}_tf_public"
  }
}

resource "aws_route_table_association" "tf_public_assoc" {
  count          =  length(aws_subnet.tf_public_subnet)
  subnet_id      =  aws_subnet.tf_public_subnet.*.id[count.index]
  route_table_id =  aws_route_table.tf_public_rt.id
}

resource "aws_route_table" "tf_web_rt" {
  vpc_id = aws_vpc.tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.tf_nat_gateway.*.id[0]
  }
  tags = {
    Name = "${var.env}_tf_web_rt"
  }
}

resource "aws_route_table_association" "tf_web_rt_assoc" {
  count          =  length(aws_subnet.tf_web_subnet)
  subnet_id      =  aws_subnet.tf_web_subnet.*.id[count.index]
  route_table_id =  aws_route_table.tf_web_rt.id
}

resource "aws_route_table" "tf_app_rt" {
  vpc_id = aws_vpc.tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.tf_nat_gateway.*.id[1]
  }
  tags = {
    Name = "${var.env}_tf_app_rt"
  }
}

resource "aws_route_table_association" "tf_private_az_2_assoc" {
  count          =  length(aws_subnet.tf_app_subnet)
  subnet_id      =  aws_subnet.tf_app_subnet.*.id[count.index]
  route_table_id =  aws_route_table.tf_app_rt.id
}

resource "aws_security_group" "bastion_sg" {
  name        = "${var.env}public_sentry_sg"
  description = "Used for access to the public sentries"
  vpc_id      = aws_vpc.tf_vpc.id

  #SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "web_sg" {
  name        = "${var.env}web_entry_sg"
  description = "Used for access to the public sentries"
  vpc_id      = aws_vpc.tf_vpc.id

  #SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }
}

resource "aws_security_group" "app_sg" {
  name        = "${var.env}app_sentry_sg"
  description = "Used for access to the public sentries"
  vpc_id      = aws_vpc.tf_vpc.id

  #SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }
}



resource "aws_security_group" "alb_sg" {
  name        = "${var.env}_alb_sg"
  description = "Used for access to the public sentries"
  vpc_id      = aws_vpc.tf_vpc.id

  #SSH
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
