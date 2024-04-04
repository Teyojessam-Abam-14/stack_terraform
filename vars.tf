# variable "AWS_ACCESS_KEY" {}
# variable "AWS_SECRET_KEY" {}
# variable "AWS_REGION" {
#   default = "us-west-2"
# }
variable "server" {
  default="serv"
}
# variable "ami" {
#   default = "ami-08f3d892de259504d"
# }
variable "vpc_id" {
  default = "vpc-0bddcac6606946cc4"
}
variable "availability_zone" {
  default = "us-west-2a"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"  
}

variable "blog_name"{
  default = "blog-lt-terraform"
}

variable "asg_name"{
  default = "blog-asg-terraform"
}

variable "subnet_ids" {
  type = list(string)
  default=[
  "subnet-03ad83ccf6cf63bf2",
  "subnet-06a58a0b0237fe923",
  "subnet-09cff0bec01b60c77",]
}

# variable "AMIS"{
#     type = map(string)
#     default = {
#         us-east-1 = "ami-08f3d892de259504d"
#         us-east-2 = "ami-06b94666"
#         us-west-1 = "ami-844e0bf7"
#     }
# }

variable "environment" {
  default = "dev"
}

variable "OwnerEmail" {
  default = "teyojessam.abam@gmail.com"
}

# variable "DB_NAME" {}
# variable "DB_USER" {}
# variable "DB_PASSWORD" {}
# variable "snapshot_identifier" {}

