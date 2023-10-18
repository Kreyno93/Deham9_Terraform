# VPC Creation using CIDR block available in vars.tf

resource "aws_vpc" "Deham9-VPC" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Deham9-VPC"
  }
}

# Define the public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.Deham9-VPC.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "eu-north-1a" # Change to your desired availability zone
  map_public_ip_on_launch = true
  tags = {
    name = "Public Subnet"
  }
}

# Define the private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.Deham9-VPC.id
  cidr_block        = "10.0.2.0/23"
  availability_zone = "eu-north-1a" # Change to your desired availability zone
  tags = {
    name = "Private Subnet"
  }
}

# Optionally, you can create an internet gateway for the VPC and attach it to the public subnet for internet access.
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.Deham9-VPC.id
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.Deham9-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
  tags = {
    name = "public route table"
  }
}

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.Deham9-VPC.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }
  tags = {
    name = "private route table"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route.id
}
