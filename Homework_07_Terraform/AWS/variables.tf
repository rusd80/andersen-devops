# variables for terraform script
variable "prefix" {
    description = "prefix for name tag"
    type = string
    default = "terraform_homework"
}

variable "vpc_cidr" {
        description     = "cidr block for vpc"
        type            = string
        default         = "10.0.0.0/16"
}

variable "key_name" {
        description     = "name of ssh key"
        type            = string
        default         = "eu-key"
}

locals {
        region          = "eu-central-1"
        cidr_block_A    = "10.0.11.0/24"
        cidr_block_B    = "10.0.12.0/24"
        bucket_name     = "bucketrusd80"
        file_name       = "index.html"
        ami             = "ami-05d34d340fb1d89e5"
        instance_type   = "t2.micro"
        script          = "script.sh"
}
