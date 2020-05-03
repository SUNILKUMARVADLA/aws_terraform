resource "aws_security_group" "bastion_sg" {
  name        = "${var.env}public_sentry_sg"
  description = "Used for access to the public sentries"
  vpc_id      = aws_vpc.tf_vpc.id


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs_sg" {
  name        = "${var.env}ecs_entry_sg"
  description = "Used for access to the containers"
  vpc_id      = aws_vpc.tf_vpc.id

  ingress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
 egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_security_group" "alb_sg" {
  name        = "${var.env}_alb_sg"
  description = "Used for access to the public sentries"
  vpc_id      = aws_vpc.tf_vpc.id


  ingress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
