variable "security_groups" {
  type = list(string)
}

variable "DB_NAME" {
    type = string
}

variable "identifier" {
  type = string
}

variable "final_snapshot_identifier"{
    type = string
}

variable "DB_USER" {
    type = string
}

variable "DB_PASSWORD" {
    type = string
}

variable "snapshot_identifier" {
    type = string
}

variable "private_subnet_a" {
  type = string
}

variable "private_subnet_b" {
  type = string
}

variable "RDS_DETAILS" {}