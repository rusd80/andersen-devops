
# VPC for this task, will content two subnets in different availablity zones
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.prefix}VPC"
  }
}

# Internet gateway gives for subnets internet access
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags = {
    Name = "${var.prefix}GW"
  }
}

# Create a subnet in availability zone A
resource "aws_subnet" "subnet_a" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "10.0.11.0/24"
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[0]
}

# Create a subnet in availability zone B
resource "aws_subnet" "subnet_b" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "10.0.12.0/24"
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[1]
}

# Allow VPC internet access
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gw.id}"
}


