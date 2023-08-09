#To Upload
/*resource "aws_s3_bucket" "bucket" {
  bucket = "tf-bucket-abam"
  acl    = "private"


  tags = {
    Name        = "TF Bucket"
    Environment = "Dev"
  }

}

#Uploading an object
 resource "aws_s3_bucket_object" "upload_file" {
  bucket = aws_s3_bucket.bucket.bucket
  key    = "sample_pic.JPG"
  source = "C://Users//teyoj//Pictures//sample_pic.JPG"
}*/


#To Download
data "aws_s3_bucket_object" "download_object" {
  bucket = "tf-bucket-abam-down"
  key    = "sample_pic.JPG"
}

resource "null_resource" "download_object" {
  provisioner "local-exec" {
    command = "aws s3 cp s3://${data.aws_s3_bucket_object.download_object.bucket}/${data.aws_s3_bucket_object.download_object.key} ./"
  }
}
