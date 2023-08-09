resource "aws_s3_bucket" "bucket" {
  bucket = "tf-bucket-abam"

  tags = {
    Name        = "TF Bucket"
    Environment = "Dev"
  }
}

#Enables versioning
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.bucket.bucket
  versioning_configuration {
    status = "Enabled"   #Replace with "Disabled" in order to disable versioning
  }
}