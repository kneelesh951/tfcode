provider "aws" {
  region = "us-east-1"  # Specify the AWS region
}

# 1. Create a VPC (Virtual Private Cloud)
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"  # CIDR block for the VPC
  tags = {
    Name = "main_vpc"  # Tag to identify the VPC
  }
}

# 2. Create a public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main_vpc.id  # VPC ID to associate the subnet
  cidr_block = "10.0.1.0/24"  # IP range for the public subnet
  availability_zone = "us-east-1a"  # Specify the availability zone
  map_public_ip_on_launch = true  # Automatically assign public IPs to instances in this subnet

  tags = {
    Name = "public_subnet"  # Tag to identify the public subnet
  }
}

# 3. Create a private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.main_vpc.id  # VPC ID to associate the subnet
  cidr_block = "10.0.2.0/24"  # IP range for the private subnet
  availability_zone = "us-east-1a"  # Specify the availability zone
  map_public_ip_on_launch = false  # No public IPs for instances in the private subnet

  tags = {
    Name = "private_subnet"  # Tag to identify the private subnet
  }
}

# 4. Create an Internet Gateway for public internet access
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id  # Associate the Internet Gateway with the VPC

  tags = {
    Name = "main_internet_gateway"  # Tag to identify the Internet Gateway
  }
}

# 5. Create a NAT Gateway for private subnet internet access (for outgoing connections)
resource "aws_eip" "nat_eip" {
  domain = "vpc"
 # Updated to use the recommended 'domain' attribute
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id  # Associate the NAT Gateway with the Elastic IP
  subnet_id     = aws_subnet.public_subnet.id  # NAT Gateway placed in the public subnet

  tags = {
    Name = "main_nat_gateway"  # Tag to identify the NAT Gateway
  }
}

# 6. Create a Route Table for the public subnet to allow public internet access
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id  # Associate the Route Table with the VPC

  # Route all internet traffic (0.0.0.0/0) to the Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_route_table"  # Tag to identify the public route table
  }
}

# 7. Associate the public subnet with the public route table
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id  # Public subnet ID
  route_table_id = aws_route_table.public_route_table.id  # Public route table ID
}

# 8. Create a Route Table for the private subnet to allow private instances outgoing access via NAT Gateway
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main_vpc.id  # Associate the Route Table with the VPC

  # Route all traffic to the NAT Gateway for private subnet instances
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "private_route_table"  # Tag to identify the private route table
  }
}

# 9. Associate the private subnet with the private route table
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet.id  # Private subnet ID
  route_table_id = aws_route_table.private_route_table.id  # Private route table ID
}

# 10. Create a Security Group for public instances (e.g., EC2 instances that need public access)
resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.main_vpc.id  # Associate the security group with the VPC

  # Inbound rule to allow HTTP (port 80) traffic from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rule to allow all traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public_sg"  # Tag to identify the public security group
  }
}

# 11. Create a Security Group for private instances (e.g., Lambda, Redshift, or EC2 that don't need public access)
resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.main_vpc.id  # Associate the security group with the VPC

  # Inbound rule to allow SSH (port 22) only from within the VPC (private)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Only allow access from inside the VPC
  }

  # Outbound rule to allow all traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private_sg"  # Tag to identify the private security group
  }
}
