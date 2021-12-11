provider "aws" {
  region  = var.region
  profile = "admin"
}

data "aws_availability_zones" "available" {}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096

  provisioner "local-exec" { # Create .pem" to your computer!!
    command = "echo '${tls_private_key.pk.private_key_pem}' > ~/.ssh/eu-key.pem"
  }
}

resource "aws_key_pair" "generated_key" {
  key_name   = "eu-key"
  public_key = tls_private_key.pk.public_key_openssh
}

# Security group for App ELB
resource "aws_security_group" "elb" {
  name        = "security_group_elb"
  vpc_id      = "${aws_vpc.vpc.id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# security group for VPC
resource "aws_security_group" "web" {
  name        = "security_group_instances"
  vpc_id      = "${aws_vpc.vpc.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "web_loadbalancer_url" {
  value = aws_lb.web.dns_name
}

