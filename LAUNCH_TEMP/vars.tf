variable clixx_name{
    type = string
}

variable "security_groups" {
  type = list(string)
}

variable "ami" {
  type = string
}

variable "PRIVATE_KEY" {
  type = string
}
 
variable "EBS_DEVICES" {} 

variable "LT_DETAILS" {}   

variable "bootstrap_file" {}
