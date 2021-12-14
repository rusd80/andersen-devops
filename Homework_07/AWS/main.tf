#-------------------------------------------------
#   Terraform and AWS training
#
#   Andersen devops courses
#
#   By Dmitrii Rusakov
#-------------------------------------------------
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
  region = local.region
}

data "aws_availability_zones" "available" {}

# Dns name output
output "web_loadbalancer_url" {
  value = aws_lb.web.dns_name
}

