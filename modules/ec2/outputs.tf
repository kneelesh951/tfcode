# Output the public IP of the EC2 instance
output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.my_ec2_instance.public_ip
}

# Output the private SSH key to access the EC2 instance
output "private_key" {
  description = "Private SSH key to log into the instance"
  value       = tls_private_key.ssh_key.private_key_pem
  sensitive   = true  # Sensitive output, hides the key in logs
}
