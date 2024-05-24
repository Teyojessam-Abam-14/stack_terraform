#For tagging
module "CORE-INFO" {
 #source="./MODULES/CORE_INFO"
 source="git::https://github.com/Teyojessam-Abam-14/stack_terraform.git//CORE_INFO?ref=stack_modules_clixx"
 count=var.stack_controls["core_info_create"] == "Y" ? 1:0
 required_tags={
  instance_name=var.instance_name
  OwnerEmail=var.OwnerEmail,
  environment=var.environment
 }
}

#For EC2 as Bastion Hosts
module "EC2-BASTION-BASE" {
 #source="./MODULES/EC2"
 source="git::https://github.com/Teyojessam-Abam-14/stack_terraform.git//EC2?ref=stack_modules_clixx"
 count=var.stack_controls["ec2_create"] == "Y" ? 1:0 
 ami=data.aws_ami.stack_ami.id
 subnets=module.VPC-BASE[0].public_subnet_ids
 EC2_DETAILS=var.EC2_DETAILS 
 PATH_TO_PUBLIC_KEY=var.PATH_TO_PUBLIC_KEY
 availability_zones=var.availability_zones
 security_groups=[aws_security_group.vpc-public-sg.id]
 s3_access=var.s3_access
 #required_tags=module.CORE-INFO[0].all_resource_tags
 bootstrap_file=base64encode(data.template_file.bastion_bootstrap.rendered)
} 

#For EFS
module "EFS-BASE"{
 #source="./MODULES/EFS"
 source="git::https://github.com/Teyojessam-Abam-14/stack_terraform.git//EFS?ref=stack_modules_clixx"
 count=var.stack_controls["efs_create"] == "Y" ? 1:0
 EFS_DETAILS=var.EFS_DETAILS
 subnets=module.VPC-BASE[0].private_subnet_ids
 security_groups=[aws_security_group.vpc-public-sg.id]
}

#For RDS
module "RDS-BASE"{
 #source="./MODULES/RDS"
 source="git::https://github.com/Teyojessam-Abam-14/stack_terraform.git//RDS?ref=stack_modules_clixx"
 count=var.stack_controls["rds_create"] == "Y" ? 1:0
 security_groups=[aws_security_group.vpc-db-sg.id]
 DB_NAME=local.db_creds.DB_NAME
 DB_PASSWORD=local.db_creds.DB_PASSWORD
 DB_USER=local.db_creds.DB_USER
 snapshot_identifier=local.db_creds.SNAPSHOT_ID
 identifier=var.identifier
 final_snapshot_identifier=var.final_snapshot_identifier
 private_subnet_a=module.VPC-BASE[0].private_subnet_a
 private_subnet_b=module.VPC-BASE[0].private_subnet_b
 RDS_DETAILS=var.RDS_DETAILS
}

#For Launch Template
module "LAUNCH-TEMP-BASE"{
 #source="./MODULES/LAUNCH_TEMP"
 source="git::https://github.com/Teyojessam-Abam-14/stack_terraform.git//LAUNCH_TEMP?ref=stack_modules_clixx"
 count=var.stack_controls["lt_create"] == "Y" ? 1:0  
 clixx_name=var.clixx_name
 security_groups=[aws_security_group.vpc-web-sg.id]
 ami=data.aws_ami.stack_ami.id
 PRIVATE_KEY=var.PRIVATE_KEY
 LT_DETAILS=var.LT_DETAILS
 EBS_DEVICES=var.EBS_DEVICES
 #required_tags=module.CORE-INFO[0].all_resource_tags
 bootstrap_file=base64encode(data.template_file.clixx_bootstrap.rendered)
}

#For Autoscaling group, Load Balancer and Route53
module "ASG-LB-BASE"{
 #source="./MODULES/ASG_LB"
 source="git::https://github.com/Teyojessam-Abam-14/stack_terraform.git//ASG_LB?ref=stack_modules_clixx"
 count=var.stack_controls["asg_lb_create"] == "Y" ? 1:0 
 vpc_id=module.VPC-BASE[0].vpc_id
 lb_name=var.lb_name
 security_groups=[aws_security_group.vpc-public-sg.id]
 private_subnet_c=module.VPC-BASE[0].private_subnet_c
 private_subnet_d=module.VPC-BASE[0].private_subnet_d
 subnet_ids=module.VPC-BASE[0].public_subnet_ids
 tg_name=var.tg_name
 asg_name=var.asg_name
 domain_name=var.domain_name
 hosted_zone_id=var.hosted_zone_id
 LB_DETAILS=var.LB_DETAILS
 TG_DETAILS=var.TG_DETAILS
 HEALTH_CHECK_DETAILS=var.HEALTH_CHECK_DETAILS
 LISTEN_DETAILS=var.LISTEN_DETAILS
 efs_mount_target=module.EFS-BASE[0].efs_mount_target
 rds_restored_db=module.RDS-BASE[0].rds_restored_db
 launch_template_id=module.LAUNCH-TEMP-BASE[0].launch_template_id
 ASG_DETAILS=var.ASG_DETAILS
 ROUTE53_DETAILS=var.ROUTE53_DETAILS
}

#For VPC
module "VPC-BASE"{
 #source="./MODULES/VPC"
 source="git::https://github.com/Teyojessam-Abam-14/stack_terraform.git//VPC?ref=stack_modules_clixx"
 count=var.stack_controls["vpc_create"] == "Y" ? 1:0 
 subnet_azs=var.subnet_azs
 public_subnet_cidr=var.public_subnet_cidr
 private_subnet_cidr=var.private_subnet_cidr
 public_subnet_names=var.public_subnet_names
 private_subnet_names=var.private_subnet_names
 SUBNET_COUNT=var.SUBNET_COUNT
 VPC_DETAILS=var.VPC_DETAILS
 IG_NAT_DETAILS=var.IG_NAT_DETAILS
 EIP_DETAILS=var.EIP_DETAILS
 PUB_RT_DETAILS=var.PUB_RT_DETAILS
 PRIV_RT_DETAILS=var.PRIV_RT_DETAILS
 VPC_ENDPOINT_DETAILS=var.VPC_ENDPOINT_DETAILS
}

