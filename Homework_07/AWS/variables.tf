
variable "prefix" {
    description = "prefix for name tag"
    type = string
    default = "terraform_homework"
}

variable "vpc_cidr" {
    description = "cidr block for vpc"
    type = string
    default = "10.0.0.0/16"
}

variable "region" {
    description = "region"
    type = string
    default = "eu-central-1"
}

variable "key_name" {
    description = "name of ssh key"
    type = string
    default = "eu-key"
}