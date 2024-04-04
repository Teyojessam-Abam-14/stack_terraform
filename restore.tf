 #Restores RDS database via shared snapshot for Blog

 resource "aws_db_instance" "restored_db" {
  allocated_storage    = 100  # Size of the storage in GB
  storage_type         = "gp2" # Storage type
  engine               = "mysql"
  engine_version       = "8.0.35"
  instance_class       = "db.t2.micro"
  identifier           = "restored-db-wordpress"
  # username             = var.DB_USER
  # password             = var.DB_PASSWORD
  parameter_group_name = "default.mysql8.0"
  # snapshot_identifier = var.snapshot_identifier
  vpc_security_group_ids = [aws_security_group.stack-sg-main.id]
  final_snapshot_identifier =  "restored-db-wordpress-identifier"
  skip_final_snapshot  = true
  publicly_accessible = true
  // You can specify other settings like security groups, VPC, etc.
}
