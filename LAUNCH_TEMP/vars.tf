variable clixx_name{
    type = string
}

variable "security_groups" {
  type = list(string)
}

variable "ami" {
  type = string
}

# variable "required_tags" {
#   type = list(object({
#     instance_name = string
#     environment = string
#     OwnerEmail = string
#   }))
# }
 
variable "EBS_DEVICES" {} 

variable "LT_DETAILS" {}   

variable "PATH_TO_PUBLIC_KEY" {}

variable "bootstrap_file" {}
