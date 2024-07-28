 #Declaring a subnet group for RDS using the private DB subnets (mySQL for this one)
 resource "aws_db_subnet_group" "vpc-tf-dbgroup" {
  name = var.RDS_DETAILS["subnet_group_name"]
  subnet_ids = [
    var.private_subnet_a, # private_subnet_mysql_1a
    var.private_subnet_b, # private_subnet_mysql_1b
  ]
 }

 #Restores RDS database via shared snapshot for Clixx
 resource "aws_db_instance" "restored_db" {
  allocated_storage    = var.RDS_DETAILS["allocated_storage"]  # Size of the storage in GB
  storage_type         = var.RDS_DETAILS["storage_type"] # Storage type
  engine               = var.RDS_DETAILS["engine"]
  engine_version       = var.RDS_DETAILS["engine_version"]
  instance_class       = var.RDS_DETAILS["instance_class"]
  identifier           = var.identifier
  username             = var.DB_USER
  password             = var.DB_PASSWORD
  parameter_group_name = var.RDS_DETAILS["parameter_group_name"]
  snapshot_identifier = var.snapshot_identifier
  vpc_security_group_ids = var.security_groups
  final_snapshot_identifier =  var.final_snapshot_identifier
  skip_final_snapshot  = var.RDS_DETAILS["skip_final_snapshot"]
  publicly_accessible = var.RDS_DETAILS["publicly_accessible"]
  db_subnet_group_name = aws_db_subnet_group.vpc-tf-dbgroup.name
  // You can specify other settings like security groups, VPC, etc.
}