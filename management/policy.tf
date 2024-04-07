#Defining and attaching bucket policy to the destination bucket
resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.dest_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "PolicyForDestinationBucket",
    Statement = [
      {
        Sid       = "ReplicationPermissions",
        Effect    = "Allow",
        Principal = {
          AWS = "arn:aws:iam::721636561061:role/Engineer"
        },
        Action    = [
          "s3:ReplicateDelete",
          "s3:ReplicateObject",
          "s3:ObjectOwnerOverrideToBucketOwner",
          "s3:GetBucketVersioning",
          "s3:PutBucketVersioning"
        ],
        Resource  = [
          "arn:aws:s3:::${var.dest_bucket_name}/*",
          "arn:aws:s3:::${var.dest_bucket_name}"
        ]
      }
    ]
  })
}
