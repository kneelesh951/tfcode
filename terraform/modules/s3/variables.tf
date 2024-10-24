# Define any input variables for your S3 module here
variable "region" {
  description = "The AWS region where S3 buckets will be created"
  type        = string
  default     = "us-east-1"
}
