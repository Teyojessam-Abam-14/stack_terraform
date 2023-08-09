resource "aws_s3_bucket" "bucket" {
  bucket = "tf-bucket-abam"
  acl    = "public-read"

  tags = {
    Name        = "TF Bucket"
    Environment = "Dev"
  }
}

#Enabling server access logging. #Target bucket and prefix must exist

resource "aws_s3_bucket_logging" "bucket_logging" {
  bucket = aws_s3_bucket.bucket.bucket
  target_bucket = "tf-bucket-abam-serverlogs"
  target_prefix = "access-logs/"
}

