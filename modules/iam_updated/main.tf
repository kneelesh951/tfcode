# Create the IAM user
resource "aws_iam_user" "migration_terraform_user" {
  name = "migration_terraform_user"
}

# Glue Policy
resource "aws_iam_policy" "glue_policy" {
  name        = "GluePolicy"
  description = "Policy for Glue related permissions"
  
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "glue:CreateDatabase",
          "glue:DeleteDatabase",
          "glue:GetDatabase",
          "glue:GetDatabases",
          "glue:CreateTable",
          "glue:UpdateTable",
          "glue:DeleteTable",
          "glue:GetTable",
          "glue:GetTables",
          "glue:StartJobRun",
          "glue:StopJobRun",
          "glue:GetJob",
          "glue:GetJobs",
          "glue:CreateJob",
          "glue:DeleteJob"
        ],
        "Resource": "*"
      }
    ]
  })
}

# Lambda Policy
resource "aws_iam_policy" "lambda_policy" {
  name        = "LambdaPolicy"
  description = "Policy for Lambda related permissions"
  
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "lambda:CreateFunction",
          "lambda:DeleteFunction",
          "lambda:UpdateFunctionCode",
          "lambda:UpdateFunctionConfiguration",
          "lambda:InvokeFunction",
          "lambda:GetFunction",
          "lambda:ListFunctions",
          "lambda:AddPermission",
          "lambda:RemovePermission",
          "lambda:GetPolicy"
        ],
        "Resource": "*"
      }
    ]
  })
}

# S3 Policy (including bucket notifications)
resource "aws_iam_policy" "s3_policy" {
  name        = "S3Policy"
  description = "Policy for S3 related permissions including bucket notifications"
  
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:CreateBucket",
          "s3:DeleteBucket",
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListObjectsV2",
          "s3:PutBucketNotification",  
          "s3:GetBucketNotification",  
          "s3:DeleteBucketPolicy"
        ],
        "Resource": "*"
      }
    ]
  })
}

# Step Functions Policy
resource "aws_iam_policy" "step_functions_policy" {
  name        = "StepFunctionsPolicy"
  description = "Policy for Step Functions related permissions"
  
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "states:StartExecution",
          "states:StopExecution",
          "states:CreateStateMachine",
          "states:DeleteStateMachine",
          "states:UpdateStateMachine",
          "states:DescribeStateMachine",
          "states:ListStateMachines",
          "states:DescribeExecution",
          "states:ListExecutions"
        ],
        "Resource": "*"
      }
    ]
  })
}

# Secrets Manager Policy
resource "aws_iam_policy" "secrets_manager_policy" {
  name        = "SecretsManagerPolicy"
  description = "Policy for AWS Secrets Manager related permissions"
  
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "secretsmanager:CreateSecret",
          "secretsmanager:DeleteSecret",
          "secretsmanager:UpdateSecret",
          "secretsmanager:GetSecretValue",
          "secretsmanager:ListSecrets",
          "secretsmanager:DescribeSecret",
          "secretsmanager:PutSecretValue",
          "secretsmanager:RestoreSecret",
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:TagResource",
          "secretsmanager:UntagResource"
        ],
        "Resource": "*"
      }
    ]
  })
}

# EC2, VPC, Elastic IP Policy
resource "aws_iam_policy" "ec2_vpc_policy" {
  name        = "EC2VPCPolicy"
  description = "Policy for EC2, VPC, and Elastic IP related permissions"
  
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ec2:CreateVpc",
          "ec2:DeleteVpc",
          "ec2:DescribeVpcs",
          "ec2:CreateSubnet",
          "ec2:DeleteSubnet",
          "ec2:DescribeSubnets",
          "ec2:CreateInternetGateway",
          "ec2:AttachInternetGateway",
          "ec2:CreateRouteTable",
          "ec2:CreateRoute",
          "ec2:AssociateRouteTable",
          "ec2:DescribeInternetGateways",
          "ec2:DescribeRouteTables",
          "ec2:AllocateAddress",  # Elastic IP actions
          "ec2:ReleaseAddress",
          "ec2:DescribeAddresses",
          "ec2:CreateNatGateway",
          "ec2:DescribeNatGateways",
          "ec2:DeleteNatGateway",
          "ec2:DescribeInstances"
        ],
        "Resource": "*"
      }
    ]
  })
}

# Attach Glue Policy to migration_terraform_user
resource "aws_iam_user_policy_attachment" "attach_glue_policy" {
  user       = aws_iam_user.migration_terraform_user.name
  policy_arn = aws_iam_policy.glue_policy.arn
}

# Attach Lambda Policy to migration_terraform_user
resource "aws_iam_user_policy_attachment" "attach_lambda_policy" {
  user       = aws_iam_user.migration_terraform_user.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# Attach S3 Policy to migration_terraform_user
resource "aws_iam_user_policy_attachment" "attach_s3_policy" {
  user       = aws_iam_user.migration_terraform_user.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

# Attach Step Functions Policy to migration_terraform_user
resource "aws_iam_user_policy_attachment" "attach_step_functions_policy" {
  user       = aws_iam_user.migration_terraform_user.name
  policy_arn = aws_iam_policy.step_functions_policy.arn
}

# Attach Secrets Manager Policy to migration_terraform_user
resource "aws_iam_user_policy_attachment" "attach_secrets_manager_policy" {
  user       = aws_iam_user.migration_terraform_user.name
  policy_arn = aws_iam_policy.secrets_manager_policy.arn
}

# Attach EC2, VPC, and Elastic IP Policy to migration_terraform_user
resource "aws_iam_user_policy_attachment" "attach_ec2_vpc_policy" {
  user       = aws_iam_user.migration_terraform_user.name
  policy_arn = aws_iam_policy.ec2_vpc_policy.arn
}
