# VPC Creation using CIDR block available in vars.tf

resource "aws_vpc" "Deham9-VPC"{
    cidr_block = var.vpc_cidr
    enable_dns_hostnames=true
    enable_dns_support = true

    tags = {
        Name = "Deham9-VPC"
    }
}