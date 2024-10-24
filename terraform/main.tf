provider "aws" {
  region = "us-east-1"  # Replace with your preferred AWS region
}

module "s3_buckets" {
  source = "./modules/s3"  # Path to your S3 module directory
}
