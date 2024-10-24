provider "aws" {
  region = "us-east-1" # Replace with your preferred region
}

# Create a basic IAM role for Step Functions to assume
resource "aws_iam_role" "step_function_role" {
  name = "basic_step_function_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "states.amazonaws.com"
        }
      }
    ]
  })
}

# Define the Step Function state machine
resource "aws_sfn_state_machine" "basic_step_function" {
  name     = "BasicStepFunction"
  role_arn = aws_iam_role.step_function_role.arn

  definition = jsonencode({
    Comment = "A simple Step Function that says Hello, World!",
    StartAt = "HelloWorld",
    States = {
      HelloWorld = {
        Type   = "Pass",
        Result = "Hello, World!",
        End    = true
      }
    }
  })
}

