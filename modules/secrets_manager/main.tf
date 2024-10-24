# Define the AWS provider and region where resources will be created
provider "aws" {
  region = var.region  # AWS region, adjustable via variable
}

# Create a new secret in AWS Secrets Manager
resource "aws_secretsmanager_secret" "example_secret" {
  name        = var.secret_name   # Name of the secret, passed as a variable
  description = var.secret_description  # Description to help identify the secret
}

# Define the secret's version and store the actual key-value pair data
resource "aws_secretsmanager_secret_version" "example_secret_version" {
  secret_id     = aws_secretsmanager_secret.example_secret.id  # Link this version to the secret above
  secret_string = jsonencode({  # Store sensitive data (like username and password) in JSON format
    username = var.secret_username,  # Database or service username
    password = var.secret_password   # Database or service password
    api_key     = "new_api_key"         # test key
    db_user     = "new_db_user"         # test db user
    db_password = "new_db_password"     # test db password
  })
}
