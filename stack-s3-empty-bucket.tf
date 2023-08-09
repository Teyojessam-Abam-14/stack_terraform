resource "aws_s3_bucket" "bucket" {
  bucket = "tf-bucket-abam"

  tags = {
    Name        = "TF Bucket"
    Environment = "Dev"
  }
}

#Creates a "empty-this-bucket" object, that will be deleted
#Once the object is created, "aws_s3_bucket_object" should be deleted before apply in order to empty the bucket

/*resource "aws_s3_bucket_object" "empty_bucket" {
  bucket = aws_s3_bucket.bucket.bucket
  key    = "empty-this-bucket"
  force_destroy = true
}*/