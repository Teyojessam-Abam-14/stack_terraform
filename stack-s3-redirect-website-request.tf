resource "aws_s3_bucket" "bucket" {
  bucket = "tf-bucket-abam"
  acl    = "private"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name        = "TF Bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_object" "index" {
  bucket = aws_s3_bucket.bucket.bucket
  key    = "index.html"
  acl    = "private"
  source = "C:\\apps\\terraform_folders\\s3_static_files\\index.html"
}

resource "aws_s3_bucket_object" "error" {
  bucket = aws_s3_bucket.bucket.bucket
  key    = "error.html"
  acl    = "private"
  source = "C:\\apps\\terraform_folders\\s3_static_files\\error.html"
}

resource "aws_s3_bucket" "redirect_bucket" {
  bucket = "tf-redirect-bucket"
  acl    = "private"
}

resource "aws_s3_bucket_object" "redirect_object" {
  bucket = aws_s3_bucket.redirect_bucket.bucket
  key    = "index.html" # This can be any key you want, as it will be redirected
  acl    = "private"
}

resource "aws_s3_bucket_website_configuration" "bucket_website" {
  bucket = aws_s3_bucket.bucket.bucket

  redirect_all_requests_to {
    host_name = aws_s3_bucket.redirect_bucket.bucket_regional_domain_name
    protocol  = "https" # Change to "http" if you want HTTP redirect
  }
}
