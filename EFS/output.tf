output "efs_mount_target" {
  value = aws_efs_mount_target.terraform_efs_mount
}

output "efs_dns" {
  value = aws_efs_file_system.terraform_efs.dns_name
}