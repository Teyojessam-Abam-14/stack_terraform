resource "aws_s3_bucket" "bucket" {
  bucket = "tf-bucket-abam"
  acl    = "private"

  tags = {
    Name        = "TF Bucket"
    Environment = "Dev"
  }
}

#Uploads index.html to bucket
resource "aws_s3_object" "static_website_files_index" {
  bucket       = aws_s3_bucket.bucket.bucket
  key          = "index.html"
  source       = "C:\\apps\\terraform_folders\\s3_static_files\\index.html"
  content_type = "text/html"
  acl          = "private"
}

#Uploads error.html to bucket
resource "aws_s3_object" "static_website_files_error" {
  bucket       = aws_s3_bucket.bucket.bucket
  key          = "error.html"
  source       = "C:\\apps\\terraform_folders\\s3_static_files\\error.html"
  content_type = "text/html"
  acl          = "private"
}

#Uploads logo.png to bucket
resource "aws_s3_object" "static_website_files_logo" {
  bucket       = aws_s3_bucket.bucket.bucket
  key          = "logo.png"
  source       = "C:\\apps\\terraform_folders\\s3_static_files\\Stack_IT_Logo.png"
  content_type = "image/png"
   acl          = "private"
}

#Configures website using the uploaded objects
resource "aws_s3_bucket_website_configuration" "tf-abam-website" {
  bucket = aws_s3_bucket.bucket.bucket
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}











