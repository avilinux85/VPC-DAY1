variable "vpc_cidr" {
  default = "10.0.0.0/16"
}


variable "subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
  default = {
    non-prod = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "ap-south-1a"
    }

    prod = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "ap-south-1b"
    }
  }
}


variable "instance_type" {
  default = "t2.micro"
}


variable "environment" {
  description = "The environment value enter as prod or non-prod"
  type        = string
}