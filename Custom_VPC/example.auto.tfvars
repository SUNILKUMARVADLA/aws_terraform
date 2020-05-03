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