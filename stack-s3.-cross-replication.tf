provider "aws" {
  alias      = "us-east-1"
  region     = "us-east-1"
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY

  assume_role {
    role_arn = "arn:aws:iam::721636561061:role/Engineer"
  }
}


resource "aws_s3_bucket" "source_bucket" {
  provider = aws.us-east-1
  bucket   = "tf-bucket-abam-source"
  acl      = "private"

  tags = {
    Name        = "TF Bucket"
    Environment = "Dev"
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "cross-region-replication-rule"
    enabled = true

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}

provider "aws" {
  alias      = "us-east-2"
  region     = "us-east-2"
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY

  assume_role {
    role_arn = "arn:aws:iam::721636561061:role/Engineer"
  }
}

resource "aws_s3_bucket" "destination_bucket" {
  provider = aws.us-east-2
  bucket   = "tf-bucket-abam-dest"
  acl      = "private"

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.source_bucket.id

  rule {
    id = "foobar"

    filter {
      prefix = "foo"
    }

    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.destination_bucket.arn
      storage_class = "STANDARD"
    }
  }
}

resource "aws_iam_role" "replication" {
  name = "S3ReplicationRole"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "replication" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.replication.name
}

resource "aws_kms_key" "replica_key" {
  description             = "KMS key for S3 cross-region replication"
  deletion_window_in_days = 30
  tags = {
    Name = "S3ReplicaKey"
  }
}
