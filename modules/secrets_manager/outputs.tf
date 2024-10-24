# Output the ARN of the created secret, useful for referencing in other modules or debugging
output "secret_arn" {
  description = "The ARN of the secret created in Secrets Manager"
  value       = aws_secretsmanager_secret.example_secret.arn
}

# Output the name of the created secret
output "secret_name" {
  description = "The name of the secret created in Secrets Manager"
  value       = aws_secretsmanager_secret.example_secret.name
}
