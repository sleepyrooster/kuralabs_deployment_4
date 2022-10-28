# VPC
resource "aws_vpc" "test_vpc" {
    cidr_block = "172.19.0.0/16"
    enable_dns_hostnames = "true"

    tags = {
        "Name" : "terraform-Deployment4-vpc"
    }
}


# Internet Gateway
resource "aws_internet_gateway" "gw_1" {
  vpc_id = aws_vpc.test_vpc.id
}

# Route Table #1
resource "aws_route_table" "route_table1" {
    vpc_id = aws_vpc.test_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw_1.id
    }
}

resource "aws_route_table_association" "route_subnet1" {
    subnet_id = aws_subnet.subnet1.id
    route_table_id = aws_route_table.route_table1.id
}

# Data
data "aws_availability_zones" "available" {
  state = "available"
}

# Subnet 1
resource "aws_subnet" "subnet1" {
    cidr_block = "172.19.0.0/18"
    vpc_id = aws_vpc.test_vpc.id
    map_public_ip_on_launch = "true"
    availability_zone = data.aws_availability_zones.available.names[0]
}
