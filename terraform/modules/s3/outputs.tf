# Output the bucket names
output "in_bucket_name" {
  value = aws_s3_bucket.in_bucket.bucket
}

output "out_bucket_name" {
  value = aws_s3_bucket.out_bucket.bucket
}

output "tmp_bucket_name" {
  value = aws_s3_bucket.tmp_bucket.bucket
}

output "export_bucket_name" {
  value = aws_s3_bucket.export_bucket.bucket
}
