resource "aws_s3_bucket" "bucket" {
  bucket = "tf-bucket-abam"
  acl    = "private"


  tags = {
    Name        = "TF Bucket"
    Environment = "Dev"
  }

  object_lock_enabled = true


}

#Enabling bucket versioning before object locking
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

 resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.bucket.bucket
  key    = "sample_pic.JPG"
  source = "C://Users//teyoj//Pictures//sample_pic.JPG"

  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.versioning]

  object_lock_legal_hold_status = "ON"
  object_lock_mode              = "GOVERNANCE"
  object_lock_retain_until_date = "2025-12-31T23:59:59Z"
  force_destroy = true
}
