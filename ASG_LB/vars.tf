variable "lb_name"{
    type = string
}

variable "security_groups" {
  type = list(string)
}

variable "subnets"{
  type = list(string)
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

variable "asg_name" {
  type = string
}

variable "efs_mount_target"{
  type = any
}

variable "rds_restored_db"{
  type = any
}

variable "launch_template_id" {
  type = string
}

variable "ASG_DETAILS" {}

variable "LB_DETAILS" {}

variable "TG_DETAILS" {}

variable "HEALTH_CHECK_DETAILS" {}

variable "LISTEN_DETAILS" {}

# variable "required_tags" {
#   type = list(object({
#     instance_name = string
#     environment = string
#     OwnerEmail = string
#   }))
# }