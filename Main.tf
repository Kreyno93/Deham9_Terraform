terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.2"
    }
  }

  required_version = ">= 0.14.9"
}

#Provider profile and region in which all the resources will creates
provider "aws" {
  access_key = "AWS_ACCESS_KEY"
  secret_key = "AWS_SECRET_ACCESS_KEY"
  region  = "eu-north-1"
}

#Resource to create s3 bucket
resource "aws_s3_bucket" "deham9-secret-bucket" {
  bucket = "deham9-secret-bucket"


  tags = {
    Name = "S3Bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "deham9-secret-bucket" {
  bucket = aws_s3_bucket.deham9-secret-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

# Define a security group to allow SSH access
resource "aws_security_group" "Deham9_Public_SG" {
  name        = "Deham9_Public_SG"
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
    Name = "Deham9_Public_SG"
  }
}


resource "aws_security_group" "Deham9_Private_SG" {
  name        = "Deham9_Private_SG"
  description = "Allow SSH from Bastion"
  vpc_id      = aws_vpc.Deham9-VPC.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Deham9_Private_SG"
  }
}

resource "aws_instance" "Deham9-Bastion" {
  ami             = "ami-06e56377934537e76" # Specify the AMI ID (Amazon Machine Image) for your desired OS
  instance_type   = "t3.micro"              # Specify the instance type
  key_name        = "Deham9-KeyPair"
  subnet_id       = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.Deham9_Public_SG.id]
  user_data       = <<-EOF
              #!/bin/bash
              exec > /var/log/user-data.log 2>&1
              yum install -y openssh-clients
              EOF

  tags = {
    Name = "Deham9-Bastion"
  }

}

resource "aws_instance" "Deham9_Private1" {
  ami             = "ami-06e56377934537e76"
  instance_type   = "t3.micro"
  subnet_id       = aws_subnet.private_subnet.id
  security_groups = [aws_security_group.Deham9_Private_SG.id]

  user_data = <<-EOF
                    #!/bin/bash
                    # Turn on password authentication for lab challenge
                    echo 'lab-password' | passwd ec2-user --stdin
                    sed -i 's|[#]*PasswordAuthentication no|PasswordAuthentication yes|g' /etc/ssh/sshd_config
                    systemctl restart sshd.service
                    sudo yum install -y docker
                    sudo systemctl start docker
                    sudo systemctl enable docker
                    sudo usermod -a -G docker ec2-user
                    sudo docker pull miischa/rickandmorty-gallery
                    sudo docker run -d -p 80:80 miischa/rickandmorty-gallery
                 EOF 

  tags = {
    Name = "Deham9_Private1"
  }
}
