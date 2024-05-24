# variable "AWS_ACCESS_KEY" {}
# variable "AWS_SECRET_KEY" {}
#NB: (Unhash the keys above when running locally, hash these again and push to Git when running on Jenkins(due to CloudBees))

variable "AWS_REGION" {
  default = "us-west-2"
}

#AMI (Finding the specified available AMI from AWS Console)
data "aws_ami" "stack_ami" {
  owners      = ["self"]
  most_recent = true

  filter {
    name   = "name"
    values = ["ami-stack-tja"]
  }
}


#List of availability zones (used in the main.tf for Bastion Instance server resource in the EC2 module)
variable "availability_zones" {
  default = ["us-west-2a", "us-west-2b"]
}

#Public key for Bastion server
variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"  
}

#S3 Bucket that contains keys (must exist in AWS Console)
variable "s3_bucket_for_keys" {
  default = "keys-for-vpc-project-b"
}

#Private key (must be present in AWS Console under 'Key Pairs') for the Launch Template
variable "PRIVATE_KEY" {
  default = "ec2_access_2"
}

#Private pem key (must exist in "s3_bucket_for_keys" S3 bucket) for the Clixx Server bootstrap
variable "PRIVATE_PEM_KEY" {
  default = "ec2_access_2.pem"
}

#EC2 IAM role that has S3 Access (must be present in AWS Console)
variable "s3_access"{
  default = "S3_Admin_Access"
}

#Name for Launch Template
variable "clixx_name"{
  default = "clixx-lt-terraform"
}

#Name for Load Balancer
variable "lb_name"{
   default = "stack-lb-terraform"
}

#Name for Target Group
variable "tg_name"{
  default = "Stack-ClIXX-TG"
}

#Name for Autoscaling Group
variable "asg_name"{
  default = "clixx-asg-terraform"
}


#Name for Server
variable "instance_name" {
  default = "Stack-server"
}

#Name of Environment (or account) for Code Deployment 
variable "environment" {
  default = "dev"
}

#The owner's email
variable "OwnerEmail" {
  default = "teyojessam.abam@gmail.com"
}

#EC2 details for the EC2 module
variable "EC2_DETAILS" {
  type=map(string)
  default={
    instance_type="t2.micro"
    volume_size=30
    volume_type="gp2"
    delete_on_termination=false
    encrypted=false
    associate_public_ip=true
  }
}

#EFS details for the EFS module
variable "EFS_DETAILS" {
  type=map(string)
  default={
    transition_to_ia = "AFTER_30_DAYS"
    encrypted = true
  }
}

#Identifer for the restored database
variable "identifier" {
  default = "restored-db-clixx"
}

#Final identifier for the restored database 
variable "final_snapshot_identifier" {
  default = "restored-db-clixx-identifier"
}

#RDS details for the RDS module
variable "RDS_DETAILS" {
  type=map(string)
  default={
    allocated_storage=100
    storage_type="gp2"
    engine="mysql"
    engine_version="8.0.33"
    instance_class="db.t2.micro"
    parameter_group_name="default.mysql8.0"
    skip_final_snapshot  = true
    publicly_accessible = true
    subnet_group_name="my-db-subnet-group-tf"
  }
}

#Launch Temp details for the Launch Temp module
variable "LT_DETAILS" {
  type=map(string)
  default = {
    instance_type = "t2.micro"
    volume_type = "gp2"
    volume_size = 8
    delete_on_termination = true
  }
}

#List of EBS devices mapped for the Lauch Temp module
variable "EBS_DEVICES" {
  type=map(string)
  default = {
    B = "/dev/sdb"
    C = "/dev/sdc"
    D = "/dev/sdd"
    E = "/dev/sde"
    G = "/dev/sdg"
  }
}

#List of EBS devices in a string for Bootstrap
variable "EBS_DEVICES_STRING"{
  default = "/dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdg"
}

#List of Volume groups in a string for Bootstrap
variable "PV_PART_STRING"{
  default = "/dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdg1"
}

#Mount point for Bootstrap
variable "MOUNT_POINT" {
  default = "/var/www/html"
}

#Load balancer details for the load balancer resource in ASG_LB module
variable "LB_DETAILS" {
  type=map(string)
  default={
    internal=false
    load_balancer_type="application"
    enable_deletion_protection=false
    enable_cross_zone_load_balancing=true
  }
}

#Target group details for the target group resource in ASG_LB module
variable "TG_DETAILS" {
  type=map(string)
  default={
    port=80
    protocol="HTTP"
  }
}

#Health check details for the target group resource in ASG_LB module
variable "HEALTH_CHECK_DETAILS" {
  type=map(string)
  default={
    enabled             = true
    healthy_threshold   = 3
    interval            = 10
    matcher             = 200
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 3
    unhealthy_threshold = 3
  }
}

#Listener details for the listener resource in ASG_LB module
variable "LISTEN_DETAILS" {
  type=map(string)
  default={
    port=80
    protocol="HTTP"
    default_action_type="forward"
  }
}

#Autoscaling group details for the autoscaling group resource in ASG_LB module
variable "ASG_DETAILS" {
  type=map(string)
  default={
    launch_template_version="$Latest"
    min_size=2
    max_size=4
    health_check_grace_period=300
    health_check_type="EC2"
    desired_capacity=4
    propagate_at_launch=true
  }
}
#VPC details for VPC resource in VPC module
variable "VPC_DETAILS" {
  type=map(string)
  default={
    cidr_block="10.0.0.0/19"
    enable_dns_hostnames=true
    instance_tenancy="default"
    name="terra_VPC-infra"
  }
}

#Subnet count for Public and Private servers
variable "SUBNET_COUNT" {
  type=map(string)
  default={
    public_count=2
    private_count=10
  }
}

#Internet and NAT Gateway details
variable "IG_NAT_DETAILS" {
  type=map(string)
  default={
    igw_name="igw-tf"
    nat_1a_name="nat_1a-tf"
    nat_1b_name="nat_1b-tf"
  }  
}

#Elastic IP details
variable "EIP_DETAILS"{
  type=map(string)
  default={
    domain="vpc"
    eip1_name="elastic_ip-tf_1"
    eip2_name="elastic_ip-tf_2"
  }
}

#Public route table details
variable "PUB_RT_DETAILS"{
  type=map(string)
  default={
    cidr_block="0.0.0.0/0"
    rt_assc_count=2
    name="public_route_table_tf"
  }
}

#Private route table details
variable "PRIV_RT_DETAILS"{
  type=map(string)
  default={
    cidr_block1="0.0.0.0/0"
    cidr_block2="0.0.0.0/1"
    rt_assc_count=10
    name="private_route_table_tf"
  }
}

#VPC Endpoint details
variable "VPC_ENDPOINT_DETAILS" {
  type=map(string)
  default={
    service_name="com.amazonaws.us-west-2.s3"
    name="stack-s3-endpoint-tf"
    policy_action="*"
    policy_effect="Allow"
    policy_resource="*"
    policy_principal="*"
  }
  
}

#Route53 details
variable "ROUTE53_DETAILS"{
  type=map(string)
  default={
    record_type="A"
    evaluate_target_health=false
  }
}

#CIDRs for Public Subnets
variable "public_subnet_cidr" {
  type    = list(any)
  default = ["10.0.4.0/23", "10.0.22.0/23"]
}

#CIDRs for Private Subnets
variable "private_subnet_cidr" {
  type    = list(any)
  default = ["10.0.12.0/22", "10.0.8.0/22", "10.0.1.0/24", "10.0.0.0/24", 
             "10.0.24.0/26", "10.0.25.0/26", "10.0.21.0/26", "10.0.27.0/26", 
             "10.0.16.0/24", "10.0.17.0/24"]
}

#List of availability zones (used in the main.tf for VPC module for public and private subnet resources)
variable "subnet_azs" {
  type    = list(any)
  default = ["us-west-2a", "us-west-2b"]
}

#List of public subnet names
variable "public_subnet_names" {
  type    = list(any)
  default = ["public_subnet_1a", "public_subnet_1b"]
}

#List of private subnet names
variable "private_subnet_names" {
  type = list(any)
  default = ["private_subnet_mysql_1a", "private_subnet_mysql_1b", "private_subnet_clixx_1a", 
             "private_subnet_clixx_1b", "private_subnet_java_1a", "private_subnet_java_1b",
             "private_subnet_javadb_1a", "private_subnet_javadb_1a", "private_subnet_oracledb_1b", 
             "private_subnet_oracledb_1b"]
}

#Hosted zone id (must exist in the console)
variable "hosted_zone_id"{
  default = "Z02780201JM7A6VMVXQ98"
}

#Domain name (must exist in the console)
variable "domain_name" {
  default = "dev-clixx-stack-teejayabam.com"
}

#Modules controls for Stack modules (Yes? or No?)
variable "stack_controls" {
  type=map(string)
  default={
    ec2_create="Y" 
    efs_create="Y"
    rds_create="Y"
    lt_create="Y"
    asg_lb_create="Y"
    vpc_create="Y"
    core_info_create="N"  #Should stay as 'N'
  }
}




