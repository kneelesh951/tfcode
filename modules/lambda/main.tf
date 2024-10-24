provider "aws" {
  region = "us-east-1"  # Set your preferred AWS region
}

# IAM role for Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "lambda_basic_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the basic execution policy (for CloudWatch logging)
resource "aws_iam_role_policy_attachment" "basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Simple Lambda function that prints "Hello World"
resource "aws_lambda_function" "hello_world_lambda" {
  function_name    = "HelloWorldLambda"  # Name of the Lambda function
  role             = aws_iam_role.lambda_role.arn  # Role for Lambda
  handler          = "lambda_function.lambda_handler"  # Lambda function handler
  runtime          = "python3.8"  # Python runtime
  filename         = "lambda_function.zip"  # Path to your zipped Lambda function code
  source_code_hash = filebase64sha256("lambda_function.zip")  # Hash for code versioning

  # Optional settings for memory and timeout
  memory_size      = 128
  timeout          = 10
}

# Output the Lambda function details
output "lambda_function_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.hello_world_lambda.function_name
}

output "lambda_function_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.hello_world_lambda.arn
}
