 #Defining and attaching S3 permissions policy to Engineering (source) role
 resource "aws_iam_policy" "policy" {
  name        = "s3_replication_permissions"
  path        = "/"
  description = "S3 Permissions for Cross Replications"

  #Defining S3 permissions policy
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "SourceBucketPermissions"
        Effect = "Allow"
        Action = [
          "s3:GetObjectRetention",
          "s3:GetObjectVersionTagging",
          "s3:GetObjectVersionAcl",
          "s3:ListBucket",
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectLegalHold",
          "s3:GetReplicationConfiguration"
        ]
        Resource = [
          "arn:aws:s3:::${var.source_bucket_name}/*",
          "arn:aws:s3:::${var.source_bucket_name}"
        ]
      },
      {
        Sid    = "DestinationBucketPermissions"
        Effect = "Allow"
        Action = [
          "s3:ReplicateObject",
          "s3:ObjectOwnerOverrideToBucketOwner",
          "s3:GetObjectVersionTagging",
          "s3:ReplicateTags",
          "s3:ReplicateDelete"
        ]
        Resource = [
          "arn:aws:s3:::${local.dest_bucket_name}/*"
        ]
      }
    ]
  })
}

#Attaching the S3 policy above to the Engineering (source) role
resource "aws_iam_policy_attachment" "attach" {
  name       = "attaching-S3-permissions-policy-to-Engineer-role"
  roles      = ["Engineer"]  
  policy_arn = aws_iam_policy.policy.arn
}
