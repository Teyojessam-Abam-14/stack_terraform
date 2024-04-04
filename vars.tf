# variable "AWS_ACCESS_KEY" {}
# variable "AWS_SECRET_KEY" {}
# variable "AWS_REGION" {
#   default = "us-east-1"
# }
variable "server" {
  default="serv"
}
# variable "ami" {
#   default = "ami-08f3d892de259504d"
# }
variable "vpc_id" {
  default = "vpc-090100b2d116aa7ce"
}
variable "availability_zone" {
  default = "us-east-1c"
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
  "subnet-008b14bb83060415e",
  "subnet-0580b95333d44c7f1",
  "subnet-073d6ae5a8faec92f",
  "subnet-0916718ca1e1b3638",
  "subnet-0d5cc12847d0e2b85",
  "subnet-0e045efcd6dfd36b3"]
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

