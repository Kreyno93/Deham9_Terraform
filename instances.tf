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

resource "aws_instance" "Deham9-Docker-Website" {
  ami             = "ami-06e56377934537e76" # Specify the AMI ID (Amazon Machine Image) for your desired OS
  instance_type   = "t3.micro"              # Specify the instance type
  key_name        = "Deham9-KeyPair"
  subnet_id       = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.Deham9_Public_SG.id]
  user_data       = <<-EOF
              #!/bin/bash
              exec > /var/log/user-data.log 2>&1
              yum install -y openssh-clients
              sudo yum install -y docker
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo usermod -a -G docker ec2-user
              sudo docker pull miischa/rickandmorty-gallery
              sudo docker run -d -p 80:3000 miischa/rickandmorty-gallery
              EOF

  tags = {
    Name = "Deham9-Docker-Website"
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
                 EOF 

  tags = {
    Name = "Deham9_Private1"
  }
}