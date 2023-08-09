resource "aws_s3_bucket" "bucket" {
  bucket = "tf-bucket-abam"
  acl    = "public-read"

  tags = {
    Name        = "TF Bucket"
    Environment = "Dev"
  }
}

#Enable object-logging via CloudTrail
resource "aws_cloudtrail" "tf_abam_bucket_logging" {
  name                          = "tf-bucket-abam-object-logging"
  s3_bucket_name                = aws_s3_bucket.bucket.bucket
  include_global_service_events = true
  is_multi_region_trail         = true

  event_selector {
    read_write_type       = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::tf-bucket-abam/*"]
    }
  }
}








