resource "aws_s3_bucket" "bucket" {
  bucket = "tf-bucket-abam"
  acl    = "private"


  tags = {
    Name        = "TF Bucket"
    Environment = "Dev"
  }


}

resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.bucket.bucket
  key    = "sample.JPG" 
  source = "C://Users//teyoj//Pictures//sample_pic.JPG"
  acl    = "private"
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket_lifecycle" {
  bucket = aws_s3_bucket.bucket.bucket
  rule {
    id      = "bucket-lifecycle-rule"
    status  = "Enabled"
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}