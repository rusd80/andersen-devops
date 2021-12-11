provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "server" {
  ami = "ami-05d34d340fb1d89e5"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.server.id]
}

resource "aws_security_group" "server" {
  name        = "server_sg"
  description = "Allow traffic"

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
    ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}