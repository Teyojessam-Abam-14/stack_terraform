#NB: Apply the destination bucket's resources and configuration first before applying the source bucket's 
#Declaring the destination bucket
resource "aws_s3_bucket" "dest_bucket" {
  bucket = "tf-teejay-dest"
  force_destroy = true

  tags = {
    Name        = "TF Destination Bucket"
    Environment = "Management"
  }
}

#Enabling versioning
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.dest_bucket.id
  versioning_configuration {
    status = "Enabled"   
  }
}
