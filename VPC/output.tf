output "vpc_id"{
    value=aws_vpc.my_vpc.id
}

output "public_subnet_ids" {
  value=aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  value=aws_subnet.private_subnets[*].id
}

output "private_subnet_a" {
  value=aws_subnet.private_subnets[0].id   #private_subnet_mysql_1a
}

output "private_subnet_b" {
  value=aws_subnet.private_subnets[1].id   #private_subnet_mysql_1b
}

output "private_subnet_c" {
  value=aws_subnet.private_subnets[2].id   #private_subnet_clixx_1a
}

output "private_subnet_d" {
  value=aws_subnet.private_subnets[3].id   #private_subnet_clixx_1b
}

