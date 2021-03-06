vpc_cidr = {
    dev = "10.0.0.0/16"
    prod = "10.1.0.0/16"
}
vpc_name  = {
    dev  = "dev-vpc"
    prod = "prod-vpc"
  }
public_cidrs = {
    dev = ["10.0.0.0/24","10.0.1.0/24"]
    prod = ["10.1.0.0/24","10.1.1.0/24"]
}
web_cidrs = {
    dev = ["10.0.10.0/24","10.0.11.0/24"]
    prod = ["10.1.10.0/24","10.1.11.0/24"]
}
app_cidrs = {
    dev = ["10.0.12.0/24","10.0.13.0/24"]
    prod = ["10.1.12.0/24","10.1.13.0/24"]
}

instance_type ={
    dev = "t2.micro"
    prod = "t2.small"
}

ubuntu_1804_x86_ami_id = {
    dev = "ami-0fc61db8544a617ed"
    prod = "ami-0fc61db8544a617ed"
}

instance_key = {
    dev = "dev_key"
    prod ="prod_key"
}

az = {
   dev={
    0 = "us-east-1a"
    1 = "us-east-1b"
   }
   prod={
    0 = "us-east-1c"
    1 = "us-east-1d"
   }
}


container_name = "test_fargate"
container_name_two = "test_fargate_tomcat"
desired_count = 3
desired_count_two = 3
fargate_cpu = 256
fargate_memory = 512
#image_url = "nginx:latest"
image_url = "131083/containercat"
image_url_two = "bradfordhamilton/crystal_blockchain:latest"
fargate_cpu_two = 1024
fargate_memory_two = 2048