resource "aws_s3_bucket" "in_bucket" {
  bucket = "in"  # S3 bucket name: in
}

resource "aws_s3_bucket" "out_bucket" {
  bucket = "out"  # S3 bucket name: out
}

resource "aws_s3_bucket" "tmp_bucket" {
  bucket = "tmp"  # S3 bucket name: tmp
}

resource "aws_s3_bucket" "export_bucket" {
  bucket = "export"  # S3 bucket name: export
}


resource "aws_s3_bucket" "export_bucket" {
  bucket = "export"  # S3 bucket name: export

}
