terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.2"
    }
  }

  required_version = ">= 0.14.9"
}

#Provider profile and region in which all the resources will create
provider "aws" {
  profile = "default"
  region  = "eu-north-1"
}

#Resource to create s3 bucket
resource "aws_s3_bucket" "bratwurstbratgeraet9000"{
  bucket = "bratwurstbratgeraet9000"

  tags = {
    Name = "S3Bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "bratwurstbratgeraet9000" {
  bucket = aws_s3_bucket.bratwurstbratgeraet9000.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

resource "aws_instance" "Deham9-EC2-Instance" {
  ami           = "ami-0ea7dc624e77a15d5" # Specify the AMI ID (Amazon Machine Image) for your desired OS
  instance_type = "t3.micro"              # Specify the instance type
  key_name = "Deham9-KeyPair"
  user_data = file("userdata.sh")

  tags = {
    Name = "Deham9_EC2_Instance"
  }

}

# Define a security group to allow SSH access
resource "aws_security_group" "Deham9-EC2-Instance-ssh" {
  name        = "Deham9-EC2-Instance-ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.Deham9-VPC.id
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Deham9-EC2-Instance-ssh"
  }
}