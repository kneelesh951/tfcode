provider "aws" {
  region = "us-east-1"  # AWS region
}

# Create an S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "test-connect-dwh"  # Hardcoded bucket name 

  # Tags for the bucket
  tags = {
    Name        = "Test Bucket"  # Tag for the bucket
    Environment = "dev"          # Environment tag
  }
}

# Create 'in/' folder in the S3 bucket
resource "aws_s3_object" "in_folder" {
  bucket  = aws_s3_bucket.my_bucket.bucket
  key     = "in/"  # Create 'in/' folder
  content = ""     # Empty content to create the folder
}

# Create 'tmp/' folder in the S3 bucket
resource "aws_s3_object" "tmp_folder" {
  bucket  = aws_s3_bucket.my_bucket.bucket
  key     = "tmp/"  # Create 'tmp/' folder
  content = ""      # Empty content to create the folder
}

# Create 'out/' folder in the S3 bucket
resource "aws_s3_object" "out_folder" {
  bucket  = aws_s3_bucket.my_bucket.bucket
  key     = "out/"  # Create 'out/' folder
  content = ""      # Empty content to create the folder
}

# Create 'export/' folder in the S3 bucket
resource "aws_s3_object" "export_folder" {
  bucket  = aws_s3_bucket.my_bucket.bucket
  key     = "export/"  # Create 'export/' folder
  content = ""         # Empty content to create the folder
}

# IAM Role for Lambda to assume
resource "aws_iam_role" "lambda_exec_simple" {
  name = "lambda_exec_role_simple"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

# IAM Policy for Lambda to access CloudWatch logs and S3
resource "aws_iam_role_policy" "lambda_policy_simple" {
  name = "lambda_policy_simple"
  role = aws_iam_role.lambda_exec_simple.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ],
        Resource = "${aws_s3_bucket.my_bucket.arn}/*"
      }
    ]
  })
}

# Create a Lambda function
resource "aws_lambda_function" "s3_event_lambda" {
  function_name = "S3EventLambdaSimple"
  role          = aws_iam_role.lambda_exec_simple.arn
  handler       = "test_event_handler.lambda_handler"
  runtime       = "python3.12"
  filename      = "test_event_handler.zip"
  source_code_hash = filebase64sha256("test_event_handler.zip")

  # Make sure Lambda function is created after the IAM role and policy
  depends_on = [aws_iam_role.lambda_exec_simple, aws_iam_role_policy.lambda_policy_simple]
}

# Grant S3 permission to invoke the Lambda function
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_event_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.my_bucket.arn
}

# S3 Bucket Notification to trigger Lambda when files are uploaded to 'in/' folder
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.my_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_event_lambda.arn
    events              = ["s3:ObjectCreated:*"]  # Trigger on object creation
    filter_prefix       = "in/"  # Only trigger for files uploaded to the 'in/' folder
  }

  # Make sure the notification is created after the Lambda permissions are set
  depends_on = [aws_lambda_permission.allow_s3]
}
