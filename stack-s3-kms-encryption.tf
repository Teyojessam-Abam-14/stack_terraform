resource "aws_s3_bucket" "bucket" {
  bucket = "tf-bucket-abam"
  acl    = "private"


  tags = {
    Name        = "TF Bucket"
    Environment = "Dev"
  }

  #Applying KMS key
  server_side_encryption_configuration {
   rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.bucket_encryption_key.arn
      sse_algorithm     = "aws:kms"
     }
   }
 }
}

#Defining KMS key
resource "aws_kms_key" "bucket_encryption_key" {
  description = "S3 KMS encryption key"
}


