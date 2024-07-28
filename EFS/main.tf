#Declaring an EFS file system
resource "aws_efs_file_system" "terraform_efs" {
  lifecycle_policy {
    transition_to_ia = var.EFS_DETAILS["transition_to_ia"]
  }
  tags = {
    Name = "terraform_efs"
  }
  
  encrypted = var.EFS_DETAILS["encrypted"]
} 

#Declaring the created-EFS file system as a mount target
resource "aws_efs_mount_target" "terraform_efs_mount" {
  count           = length(var.subnets) >= 4 ? 2 : 0
  file_system_id = aws_efs_file_system.terraform_efs.id
  subnet_id   =  var.subnets[count.index] 
  security_groups = var.security_groups
  depends_on      = [aws_efs_file_system.terraform_efs]
}