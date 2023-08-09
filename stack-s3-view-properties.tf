resource "aws_s3_bucket" "bucket" {
  bucket = "tf-bucket-abam"

  tags = {
    Name        = "TF Bucket"
    Environment = "Dev"
  }
}

#Get data about the bucket
data "aws_s3_bucket" "view_prop"{
  bucket = aws_s3_bucket.bucket.bucket
}

#Prints output about the data
output "bucket_properties" {
  value = data.aws_s3_bucket.view_prop
}