# Define the AWS region where the secret should be created
variable "region" {
  description = "The AWS region to use for this configuration"
  type        = string
  default     = "us-east-1"  # Default region is set to us-east-1
}

# Define the name of the secret
variable "secret_name" {
  description = "The name you want to give to the secret in AWS Secrets Manager"
  type        = string
  default     = "test_secret_name"  # Default name is 'test_secret_name'
}

# A short description for what this secret contains
variable "secret_description" {
  description = "A description for the secret (e.g., what it stores)"
  type        = string
  default     = "This secret contains database credentials"
}

# Define the username to be stored in the secret
variable "secret_username" {
  description = "The username that will be stored in the secret"
  type        = string
  default     = "test_user"  # Default username for testing
}

# Define the password to be stored in the secret
variable "secret_password" {
  description = "The password that will be stored in the secret"
  type        = string
  default     = "test_password"  # Default password for testing
}
