#To Upload
resource "aws_s3_bucket" "bucket" {
  bucket = "tf-bucket-abam"
  acl    = "private"


  tags = {
    Name        = "TF Bucket"
    Environment = "Dev"
  }

}
#Commenting out object block to delete it from the bucket
/*
 resource "aws_s3_bucket_object" "upload_file" {
  bucket = aws_s3_bucket.bucket.bucket
  key    = "sample_pic.JPG"
  source = "C://Users//teyoj//Pictures//sample_pic.JPG"
}*/

