variable "subnet_azs" {
  type = list(any)
}

variable "public_subnet_cidr" {
   type = list(any)
}

variable "private_subnet_cidr" {
   type = list(any)
}

variable "public_subnet_names" {
  type = list(any)
}

variable "private_subnet_names" {
  type = list(any)
}


variable "SUBNET_COUNT" {}
variable "VPC_DETAILS" {}
variable "IG_NAT_DETAILS" {}
variable "EIP_DETAILS"{}
variable "PUB_RT_DETAILS"{}
variable "PRIV_RT_DETAILS"{}
variable "VPC_ENDPOINT_DETAILS" {}