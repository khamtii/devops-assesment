provider "aws" {
  region = "us-east-1"
}

# VPC 
resource "aws_vpc" "Assetrix_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Subnet
resource "aws_subnet" "Assetrix_subnet" {
  vpc_id                  = aws_vpc.Assetrixo_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

# Internet Gateway
resource "aws_internet_gateway" "Assetrix_igw" {
  vpc_id = aws_vpc.Assetrix_vpc.id
}

# Route Table
resource "aws_route_table" "Assetrix_rt" {
  vpc_id = aws_vpc.Assetrix_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Assetrix_igw_igw.id
  }
}

resource "aws_route_table_association" "Assetrix_rta" {
  subnet_id      = aws_subnet.Assetrix_subnet.id
  route_table_id = aws_route_table.Assetrix_rt.id
}

# Security Group
resource "aws_security_group" "Assetrix_sg" {
  vpc_id = aws_vpc.Assetrix_vpc.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
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

# EC2 Instance
resource "aws_instance" "Assetrix_node_app" {
  ami           = "ami-08c40ec9ead489470" # Ubuntu 22.04 LTS in us-east-1
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.Assetrix_subnet.id
  vpc_security_group_ids = [aws_security_group.Assetrix_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io
              systemctl start docker
              systemctl enable docker
              docker run -d -p 80:3000 $DOCKERHUB_USERNAME/node-app
              EOF

  tags = {
    Name = "node-app"
  }
}

