variable "AWS_REGION" {
  default = "us-east-1"
}

variable "ami" {
  type = string
}

variable "vpc_id" {}

variable "subnets" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}

variable "EC2_DETAILS" {}

variable "availability_zone" {
  default = "us-east-1c"
}

variable "PATH_TO_PUBLIC_KEY" {}
   
# variable "required_tags" {
#   type = list(object({
#     instance_name = string
#     environment = string
#     OwnerEmail = string
#   }))
# }


variable "bootstrap_file" {}