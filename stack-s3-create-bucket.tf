resource "aws_s3_bucket" "bucket" {
  bucket = "tf-bucket-abam"
  force_destroy = true

  tags = {
    Name        = "TF Bucket"
    Environment = "Dev"
  }
}