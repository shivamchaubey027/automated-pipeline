data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] 
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "automated-pipeline" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "apSubnet" {
  vpc_id = aws_vpc.automated-pipeline.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true
  tags ={
    name= "apSubnet"
  }

}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.automated-pipeline.id

}

resource "aws_route_table" "table" {
    vpc_id = aws_vpc.automated-pipeline.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}

resource "aws_route_table_association" "name" {
  subnet_id = aws_subnet.apSubnet.id
  route_table_id = aws_route_table.table.id
}

resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.automated-pipeline.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecr_repository" "ecr" {
  name = "automated-pipeline-repo"

}

resource "aws_instance" "ec2" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id = aws_subnet.apSubnet.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name = aws_key_pair.key.key_name

}

resource "aws_key_pair" "key" {
  key_name = "my-aws-key"
  public_key = file("./my-key.pub")
}