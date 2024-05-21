variable "ami" {
  type = string
}

variable "subnets" {
  type = any
}

variable "security_groups" {
  type = list(string)
}

variable "s3_access" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "EC2_DETAILS" {}

variable "PATH_TO_PUBLIC_KEY" {}

variable "bootstrap_file" {}

# variable "required_tags" {
#   type = any
# }