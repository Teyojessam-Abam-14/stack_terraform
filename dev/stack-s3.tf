#Declaring the source bucket
resource "aws_s3_bucket" "source_bucket" {
  bucket = "tf-teejay-source"
  force_destroy = true

  tags = {
    Name        = "TF Source Bucket"
    Environment = "Dev"
  }
}

#Enabling versioning
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.source_bucket.id
  versioning_configuration {
    status = "Enabled"   
  }
}

#Defining and attaching a replication rule to the source bucket that will allow replication to the destination bucket
resource "aws_s3_bucket_replication_configuration" "s3_replication_rule" {
  bucket = aws_s3_bucket.source_bucket.id

  role = "arn:aws:iam::721636561061:role/Engineer"

  rule {
    id       = "rule-1"
    status   = "Enabled"
    priority = 10

    delete_marker_replication {
      status = "Disabled"
    }

    filter {
      prefix = ""
    }

    destination {
      bucket = "arn:aws:s3:::${local.dest_bucket_name}"
    }
  }
}

#Uploading an object to source bucket
 resource "aws_s3_object" "s3_file" {
  bucket = aws_s3_bucket.source_bucket.id
  key    = "index.html"
  source = "../../s3_static_files/index.html"
}





