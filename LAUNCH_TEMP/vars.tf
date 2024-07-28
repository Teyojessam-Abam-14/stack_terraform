variable master_node_name{
    type = string
}

variable worker_node_name{
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

variable "master_bootstrap_file" {}

variable "worker_bootstrap_file" {}
