# variable "AWS_ACCESS_KEY" {}

# variable "AWS_SECRET_KEY" {}

variable "AWS_REGION" {
  default = "us-east-1"
}

variable "source_bucket_name" {
  default = "tf-teejay-source"
}

#This collects data from the "management"'s already-applied resources/configuration; used to get the destination bucket's name
#Therefore, "management"'s (the destination) resources/configuration must be applied first before "dev"'s (the source)
data "terraform_remote_state" "management" {
  backend = "local"

  config = {
    path = "../management/terraform.tfstate" #management's state file
  }
}

#Defining destination bucket name local variable by collecting the output of the name data of the destination bucket using "management"'s state file
locals {
  dest_bucket_name = data.terraform_remote_state.management.outputs.dest_bucket_output
}


