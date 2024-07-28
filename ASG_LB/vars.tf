variable "lb_name"{
    type = string
}

variable "security_groups" {
  type = list(string)
}

variable "private_subnet_c"{
  type = string
}

variable "private_subnet_d"{
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "tg_name"{
  type = string
}

variable "k8_master_asg_name" {
  type = string
}

variable "k8_worker_asg_name" {
  type = string
}


variable "efs_mount_target"{
  type = any
}

variable "rds_restored_db"{
  type = any
}

variable "master_launch_template_id" {
  type = string
}

variable "worker_launch_template_id" {
  type = string
}

variable "hosted_zone_id"{
  type = string
}

variable "domain_name" {
  type = string
}

variable "ASG_DETAILS" {}

variable "LB_DETAILS" {}

variable "TG_DETAILS" {}

variable "HEALTH_CHECK_DETAILS" {}

variable "LISTEN_DETAILS" {}

variable "ROUTE53_DETAILS" {}

# variable "required_tags" {
#   type = list(object({
#     instance_name = string
#     environment = string
#     OwnerEmail = string
#   }))
# }