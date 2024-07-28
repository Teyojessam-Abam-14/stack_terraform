#Bootstrap for K8 Master
data "template_file" "k8_master_bootstrap" {
  template = file(format("%s/scripts/k8_master_btstrap.tpl", path.module))
  vars={
    EFS_DNS = module.EFS-BASE[0].efs_dns
    DB_HOST = local.DB_HOST_CLIXX
    CLIXX_LB = module.ASG-LB-BASE[0].lb_dns
    MOUNT_POINT = var.MOUNT_POINT
    DB_NAME_CLIXX = local.db_creds.DB_NAME
    DB_PASS_CLIXX = local.db_creds.DB_PASSWORD
    DB_USER_CLIXX = local.db_creds.DB_USER
  }
}

#Bootstrap for K8 Worker
data "template_file" "k8_worker_bootstrap" {
  template = file(format("%s/scripts/k8_worker_btstrap.tpl", path.module))
  vars={
    EFS_DNS = module.EFS-BASE[0].efs_dns
    MOUNT_POINT = var.MOUNT_POINT
  }
}

#Retrieving Clixx DB secrets from US-East-1's Secrets Manager in AWS Console (must exist already)
data "aws_secretsmanager_secret_version" "creds" {
  secret_id     = "clixx_db_secrets"
  version_stage = "AWSCURRENT"
}

locals {
  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}

#Setting up configuration for boostrap for Bastion server
data "template_file" "bastion_bootstrap" {
  template = file(format("%s/scripts/bastion_clixx_btstrap.tpl", path.module))
  vars={
      S3_BUCKET=var.s3_bucket_for_keys
      PEM_KEY=var.PRIVATE_PEM_KEY
    }
}

#Removes ":3306" from the endpoint string
locals {
  DB_HOST_CLIXX = replace(module.RDS-BASE[0].rds_endpoint, ":3306", "")
}

#Outputs the load balancer domain name
output "load_balancer_dns_name" {
  value = module.ASG-LB-BASE[0].lb_dns
}

#NB: Unhash the above once the VPC module works

# data "template_file" "bootstrap" {
#   template = file(format("%s/scripts/sample_gen_btstrap.tpl", path.module))
#   vars={
#     GIT_REPO ="https://github.com/stackitgit/CliXX_Retail_Repository.git"
#   }
# }



# data "template_file" "clixx_bootstrap" {
#   template = file(format("%s/scripts/sample_clixx_btstrap.tpl", path.module))
#   vars={
#     GIT_REPO ="https://github.com/stackitgit/CliXX_Retail_Repository.git"
#     EFS_DNS = module.EFS-BASE[0].efs_dns
#     DB_HOST = local.DB_HOST_CLIXX
#     CLIXX_LB = module.ASG-LB-BASE[0].lb_dns
#     MOUNT_POINT = var.MOUNT_POINT
#     EBS_DEVICES = var.EBS_DEVICES_STRING
#     PV_PART_STRING = var.PV_PART_STRING
#     DB_NAME_CLIXX = local.db_creds.DB_NAME
#     DB_PASS_CLIXX = local.db_creds.DB_PASSWORD
#     DB_USER_CLIXX = local.db_creds.DB_USER
#   }
# }
