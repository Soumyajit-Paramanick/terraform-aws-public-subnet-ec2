provider "aws" {
  region = var.region
}
resource "aws_vpc" "our_vpc" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = "terraform-vpc"
    }
}
resource "aws_subnet" "our_subnet" {
    vpc_id = aws_vpc.our_vpc.id
    cidr_block = var.subnet_cidr
    map_public_ip_on_launch = true
    tags = {
        Name = "terraform-subnet"
    }
}
resource "aws_internet_gateway" "our_internet_gateway" {
    vpc_id = aws_vpc.our_vpc.id
    tags = {
        Name = "terraform-internet-gateway"
    }
}
resource "aws_route_table" "our_route_table" {
    vpc_id = aws_vpc.our_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.our_internet_gateway.id
    }
    tags = {
        Name = "terraform-route-table"
    }
}
resource "aws_route_table_association" "our_route_table_association" {
    subnet_id = aws_subnet.our_subnet.id
    route_table_id = aws_route_table.our_route_table.id
}
resource "aws_security_group" "our_security_group" {
    vpc_id = aws_vpc.our_vpc.id
    tags = {
      Name = "terraform-security-group"
    }
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "our_ec2_instance" {
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
    subnet_id     = aws_subnet.our_subnet.id
    vpc_security_group_ids = [aws_security_group.our_security_group.id]
    tags = {
        Name = "terraform-ec2-instance"
    }
}