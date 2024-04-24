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

variable "PATH_TO_PUBLIC_KEY" {}
   
# variable "required_tags" {
#   type = any
# }

variable "bootstrap_file" {}