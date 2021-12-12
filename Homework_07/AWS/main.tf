terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.69.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
}

data "aws_availability_zones" "available" {}

# output
output "web_loadbalancer_url" {
  value = aws_lb.web.dns_name
}

