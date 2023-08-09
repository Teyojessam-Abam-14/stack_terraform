/*resource "aws_s3_bucket" "bucket" {
  bucket = "tf-bucket-abam"
  force_destroy = true

  tags = {
   Name        = "TF Bucket"
   Environment = "Dev"
  }
}*/

#"terraform destroy" should be run in the terminal after creating a bucket in order to delete the bucket