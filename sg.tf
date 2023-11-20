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

resource "aws_security_group" "aurora_db_security_group" {
  name        = "aurora-db-sg"
  description = "Security group for Aurora database"

  ingress {
    from_port = 3306  # Assuming your Aurora database is using the default MySQL port
    to_port   = 3306
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Adjust the CIDR block to match your specific requirements
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}