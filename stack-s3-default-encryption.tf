resource "aws_s3_bucket" "bucket" {
  bucket = "tf-bucket-abam"
  acl    = "public-read"

  tags = {
    Name        = "TF Bucket"
    Environment = "Dev"
  }
  
  #Defaults to AES256 encryption
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256" 
    }
  }
}

}

