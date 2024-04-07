# variable "AWS_ACCESS_KEY" {}

# variable "AWS_SECRET_KEY" {}

variable "AWS_REGION" {
  default = "us-east-1"
}

variable "dest_bucket_name" {
  default = "tf-teejay-dest"
}

#Getting the output of the destination bucket name to use in dev (the source)
output "dest_bucket_output" {
  value = var.dest_bucket_name
}

