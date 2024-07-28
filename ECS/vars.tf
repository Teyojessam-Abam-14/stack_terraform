variable "tg_arn"{
  type = any
}

variable "cluster_name"{
  type = string
}

variable "container_name" {
  type = any
}

variable "container_image" {
  type = string
}

variable "container_essential" {
  type = bool
}

variable "CONT_MEMORY_PORT_MAP_DETAILS"{}
variable "TASK_DEF_DETAILS"{}
variable "SERVICE_DETAILS"{}