# Create the VPC
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  tags = {
    Name = "VPC-MAIN-ASG"
  }
}

# Create the private subnet
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr
  availability_zone = var.availability_zone_b
  tags = {
    Name = "PRISUB-MAIN-ASG"
  }
}

# Create the public subnets
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr
  availability_zone = var.availability_zone_a
  tags = {
    Name = "PUBSUB1-MAIN-ASG"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# Create a route table
resource "aws_route_table" "rt01" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Associate the route table with the public subnets
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.rt01.id
}

# Create security groups for public and private instances
resource "aws_security_group" "public_sg" {
  name        = "SG-PUB-MAIN-ASG"
  description = "Security group for public instances in VPC"

  vpc_id = aws_vpc.main.id

  ingress {
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

resource "aws_security_group" "private_sg" {
  name        = "SG-PRI-MAIN-ASG"
  description = "Security group for private instances in VPC"

  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch EC2 instances in the public and private subnets
resource "aws_instance" "public_instance" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  key_name      = var.key_name
  associate_public_ip_address = "true"

  vpc_security_group_ids = [aws_security_group.public_sg.id]

  tags = {
    Name = "PUB-LINUX"
  }
}

resource "aws_instance" "private_instance" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private.id
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.private_sg.id]

  tags = {
    Name = "PRI-LINUX"
  }
}

# Define Elastic IP for NAT Gateway
resource "aws_eip" "my_eip" {
  domain = "vpc"
}

# Create the NAT Gateway
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.public.id
}

# Create a new route table for the private subnet
resource "aws_route_table" "rt02" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }
}

# Associate the new route table with the private subnet
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.rt02.id
}
