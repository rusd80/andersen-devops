provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "server" {
  ami = "ami-05d34d340fb1d89e5"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.server.id]
  user_data = <<EOF
#!/bin/bash
sudo yum -y update
sudo amazon-linux-extras install nginx1 -y
sudo systemctl start nginx
sudo systemctl enable nginx
EOF
}

resource "aws_security_group" "server" {
  name        = "server_sg"
  description = "Allow traffic"

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_traffic"
  }
}