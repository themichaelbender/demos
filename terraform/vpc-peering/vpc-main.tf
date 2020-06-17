variable "region" {
  default = "us-west-2"
}

provider "aws" {
  version = "~> 2.0"
  region  = var.region
}

resource "aws_vpc" "eu_vpc" {
  cidr_block       = "172.16.0.0/16"
  instance_tenancy = "default"

  tags   = {
    Name = "EU Lab VPC"
  }
}

resource "aws_internet_gateway" "lab_vpc_gateway" {
  vpc_id = aws_vpc.lab_vpc.id
}

resource "aws_route" "lab_vpc_internet_access" {
  route_table_id         = aws_vpc.lab_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.lab_vpc_gateway.id
}

resource "aws_subnet" "eu_vpc_" {
  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = "172.16.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-2a"
}



data "aws_caller_identity" "current" {
  # no args
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name = "owner-alias"
    values = [ "amazon" ]
  }
  filter {
    name = "name"
    values = ["amzn2-ami-hvm*"]
  }
  owners = ["137112412989"]
  #owners = ["${data.aws_caller_identity.current.account_id}"]
}

resource "aws_security_group" "lab_ec2_security_group" {
    description = "EC2 Security Group - SSH & ICMP"
    egress      = [
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = ""
            from_port        = 0
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "-1"
            security_groups  = []
            self             = false
            to_port          = 0
        },
    ]
    ingress     = [
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = ""
            from_port        = 0
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "-1"
            security_groups  = []
            self             = false
            to_port          = 0
        },
    ]
    name        = "lab_ec2_security_group"
    tags        = {}
    vpc_id      = aws_vpc.lab_vpc.id

    timeouts {}
}

resource "aws_instance" "eu_site" {
    ami                          = data.aws_ami.amazon_linux.id
    associate_public_ip_address  = true
    availability_zone            = "us-west-2a"
    instance_type                = "t2.nano"
    monitoring                   = false
    subnet_id                    = aws_subnet.lab_vpc_subnet_a.id
    tags                         = { Name = "Site 2a" }
    vpc_security_group_ids		   = [aws_security_group.lab_ec2_security_group.id]
}



resource "aws_instance" "lab_carved_rock_forum_2a" {
    ami                          = data.aws_ami.amazon_linux.id
    associate_public_ip_address  = true
    availability_zone            = "us-west-2a"
    instance_type                = "t2.nano"
    monitoring                   = false
    subnet_id                    = aws_subnet.lab_vpc_subnet_a.id
    tags                         = { Name = "Forum 2a" }
    vpc_security_group_ids       = [aws_security_group.lab_ec2_security_group.id]
}

resource "aws_instance" "lab_carved_rock_forum_2b" {
    ami                          = data.aws_ami.amazon_linux.id
    associate_public_ip_address  = true
    availability_zone            = "us-west-2b"
    instance_type                = "t2.nano"
    monitoring                   = false
    subnet_id                    = aws_subnet.lab_vpc_subnet_b.id
    tags                         = { Name = "Forum 2b" }
    vpc_security_group_ids       = [aws_security_group.lab_ec2_security_group.id]
}

resource "aws_instance" "lab_carved_rock_forum_2c" {
    ami                          = data.aws_ami.amazon_linux.id
    associate_public_ip_address  = true
    availability_zone            = "us-west-2c"
    instance_type                = "t2.nano"
    monitoring                   = false
    subnet_id                    = aws_subnet.lab_vpc_subnet_c.id
    tags                         = { Name = "Forum 2c" }
    vpc_security_group_ids       = [aws_security_group.lab_ec2_security_group.id]
}
