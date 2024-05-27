variable "environment_tag" {
  description = "Environment tag"
  default     = "Learn"
}

variable "region" {
  description = "The region Terraform deploys your instance"
  default     = "us-east-1"
}

variable "vpc_id" {
  default = "vpc-021e644d2e597530f"
}

variable "subnets" {
  type = list(string)
  default = [
    "subnet-0e639e1fa9398df1d",
    "subnet-080034a17d33646f0",
    "subnet-09292316dda8abebc",
    "subnet-055b8e19ab2d3b6a5",
    "subnet-087e1492686741b4a",
    "subnet-00810c3a6801aa534"
  ]
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "ses_key.pub"
}

# variable "cidr_vpc" {
#   description = "CIDR block for the VPC"
#   default     = "10.1.0.0/16"
# }
# variable "cidr_subnet" {
#   description = "CIDR block for the subnet"
#   default     = "10.1.0.0/24"
# }

# variable "ami_name" {
#   default = "ami-stack-51"
# }