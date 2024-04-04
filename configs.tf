#Setting up configuration for boostrap
data "template_file" "bootstrap" {
  template = file(format("%s/scripts/sample_wpblog_btstrap.tpl", path.module))
  vars={
      GIT_REPO="https://github.com/Teyojessam-Abam-14/wordpress_blog.git"
      MOUNT_POINT="/var/www/html"
      EFS_DNS = aws_efs_file_system.terraform_efs.dns_name
      DB_HOST = local.DB_HOST_BLOG
      BLOG_LB = aws_lb.stack-lb.dns_name
      # DB_NAME_BLOG = var.DB_NAME
      # DB_PASS_BLOG = var.DB_PASSWORD
      # DB_USER_BLOG = var.DB_USER
    }
}


#Removes ":3306" from the endpoint string
locals {
  DB_HOST_BLOG = replace(aws_db_instance.restored_db.endpoint, ":3306", "")
}


#Pulls subnets from default VPC in the AWS console
data "aws_subnets" "selected" {
  filter {
    name = "vpc-id"
    values = [var.vpc_id]
  }
}

#Pulls the available "ami-stack-tja" AMI from the AWS console
data "aws_ami" "stack_ami" {
  owners      = ["self"]
  most_recent = true

  filter {
    name   = "name"
    values = ["ami-stack-tja"]
  }
}

#Outputs the endpoint string
output "rds_endpoint" {
  value = replace(aws_db_instance.restored_db.endpoint, ":3306", "")
}

#Outputs the load balancer domain name
output "load_balancer_dns_name" {
  value = aws_lb.stack-lb.dns_name
}