variable "profile"{
    type = string
    default = "profile2"
}

variable "region"{
    type = string
    default = "us-east-1"
}

variable "env"{
    description = "env: dev or prod"
}


variable "vpc_name" {
  type        = map
  description = "Name for vpc"
}
variable "vpc_cidr"{
    type = map
}

variable "public_cidrs"{
    type = map
}

variable "az"{
    type=map
}

variable "web_cidrs"{
    type = map
}

variable "app_cidrs"{
     type = map
}

variable "instance_type"{
    type = map
}

variable "ubuntu_1804_x86_ami_id" {
  type = map
}

variable "instance_key"{
    type = map
}
 variable "app_port"{
     default = 80
 }

  variable "app_port_two"{
     default = 3000
 }


variable "container_name" {}
variable "desired_count" {}
variable "fargate_cpu" {}
variable "fargate_memory" {}
variable "image_url" {}
variable "container_name_two" {}
variable "desired_count_two" {}
variable "image_url_two" {}
variable "fargate_cpu_two" {}
variable "fargate_memory_two" {}