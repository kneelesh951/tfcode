# Provider configuration
provider "aws" {
  region = "us-east-1"  # Specify your AWS region
}

# Attach the AmazonEC2FullAccess policy to the IAM user
resource "aws_iam_user_policy_attachment" "terraform_user_ec2_full_access" {
  user       = "terraform-user"  # Replace with your IAM user
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"  # Predefined AWS policy
}

# Security Group for EC2 instance
resource "aws_security_group" "ec2_security_group" {
  name        = "ec2_security_group"
  description = "Allow SSH inbound traffic"

  # Inbound rule to allow SSH access on port 22
  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open to the world (not secure in production)
  }

  # Outbound rule to allow all traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Generate SSH key pair for EC2 access
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096  # Key strength
}

# Import the SSH public key into AWS as a Key Pair
resource "aws_key_pair" "deployer_key" {
  key_name   = "deployer_key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# Create an EC2 instance
resource "aws_instance" "my_ec2_instance" {
  ami           = "ami-0c55b159cbfafe1f0"  # Replace with your region-specific AMI
  instance_type = "t2.micro"  # Free tier instance
  key_name      = aws_key_pair.deployer_key.key_name  # SSH key for access

  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]  # Attach security group

  tags = {
    Name = "MyTerraformEC2"  # Tag the instance
  }

  # Optional: User data script that runs on instance creation
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World from EC2" > /home/ec2-user/hello.txt
              EOF
}
