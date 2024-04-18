output "rds_restored_db"{
    value = aws_db_instance.restored_db
}

output "rds_endpoint"{
    value = aws_db_instance.restored_db.endpoint
}