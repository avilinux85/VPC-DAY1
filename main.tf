### Creating Custom VPC with CIDR
resource "aws_vpc" "custom" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = upper("custom vpc")
  }
}

### Creating Subnets for Non Prod Instance ##############
resource "aws_subnet" "non_prod_subnet" {
  vpc_id            = aws_vpc.custom.id
  cidr_block        = var.subnets["non-prod"].cidr_block
  availability_zone = var.subnets["non-prod"].availability_zone

  tags = {
    Name = upper("non-prod-Subnet")
  }
}

##### Creating Subnets for Prod ###################
resource "aws_subnet" "prod_subnet" {
  vpc_id            = aws_vpc.custom.id
  cidr_block        = var.subnets["prod"].cidr_block
  availability_zone = var.subnets["prod"].availability_zone

  tags = {
    Name = upper("prod-Subnet")
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.custom.id
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.custom.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "non-prod-route-association" {
  subnet_id      = aws_subnet.non_prod_subnet.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "prod-route-association" {
  subnet_id      = aws_subnet.prod_subnet.id
  route_table_id = aws_route_table.public_route.id
}


resource "aws_instance" "ec2" {
  ami           = data.aws_ami.example_ami.id
  instance_type = var.instance_type

  subnet_id = var.environment == "prod" ? aws_subnet.prod_subnet.id : aws_subnet.non_prod_subnet.id
  tags = {
    Name = var.environment == "prod" ? upper("prod_instance") : upper ("nonprod_instance")
  }
}