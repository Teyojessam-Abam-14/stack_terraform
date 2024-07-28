#Declaring a Virtual Private Cloud a.k.a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = var.VPC_DETAILS["cidr_block"]
  enable_dns_hostnames = var.VPC_DETAILS["enable_dns_hostnames"]
  instance_tenancy     = var.VPC_DETAILS["instance_tenancy"]
  tags = {
    Name = var.VPC_DETAILS["name"]
  }
}


#Here add all your 8 CIDR's to the list in "subnet_cidr" and for each one add one entry in "subnet_azs". 
#You can repeat values in "subnet_azs" but not in subnet_cidr"

#Declaring public subnets (for Bastion Servers)
resource "aws_subnet" "public_subnets" {
  count             = var.SUBNET_COUNT["public_count"]
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = element(var.public_subnet_cidr, count.index)
  availability_zone = element(var.subnet_azs, count.index)
  tags = {
    Name = var.public_subnet_names[count.index]
  }
}

#Declaring private subnets (for Application and Database servers)
resource "aws_subnet" "private_subnets" {
  count             = var.SUBNET_COUNT["private_count"]
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = element(var.private_subnet_cidr, count.index)
  availability_zone = element(var.subnet_azs, count.index)
  tags = {
    Name = var.private_subnet_names[count.index]
  }
}

#Declaring internet gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = var.IG_NAT_DETAILS["igw_name"]
  }
}

#Declaring an EIP for NAT Gateway 1A
resource "aws_eip" "eip1" {
  domain = var.EIP_DETAILS["domain"]
  tags = {
    Name = var.EIP_DETAILS["eip1_name"]
  }
}

#Declaring an EIP for NAT Gateway 1B
resource "aws_eip" "eip2" {
  domain = var.EIP_DETAILS["domain"]
  tags = {
    Name = var.EIP_DETAILS["eip2_name"]
  }
}

#Declaring NAT gateway 1A for the first public subnet
resource "aws_nat_gateway" "nat_1a" {
  allocation_id = aws_eip.eip1.allocation_id
  subnet_id     = aws_subnet.public_subnets[0].id
  tags = {
    Name = var.IG_NAT_DETAILS["nat_1a_name"]
  }
}

#Declaring NAT gateway 1B for the second public subnet
resource "aws_nat_gateway" "nat_1b" {
  allocation_id = aws_eip.eip2.allocation_id
  subnet_id     = aws_subnet.public_subnets[1].id
  tags = {
    Name = var.IG_NAT_DETAILS["nat_1b_name"]
  }
}


#Declaring a public route table using internet gateway
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = var.PUB_RT_DETAILS["cidr_block"]
    gateway_id = aws_internet_gateway.my_igw.id  #Internet gateway
  }
  tags = {
    Name = var.PUB_RT_DETAILS["name"]
  }
}

#Declaring a private route table using NAT gateway
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = var.PRIV_RT_DETAILS["cidr_block1"]
    nat_gateway_id = aws_nat_gateway.nat_1a.id  #NAT gateway 1A
  }

  route {
    cidr_block = var.PRIV_RT_DETAILS["cidr_block2"]
    nat_gateway_id = aws_nat_gateway.nat_1b.id  #NAT gateway 1B
  }

    tags = {
    Name = var.PRIV_RT_DETAILS["name"]
  }
}

#Associating the public route table with the public subnets
resource "aws_route_table_association" "public_route_table_association" {
  count          = var.PUB_RT_DETAILS["rt_assc_count"]
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

#Associating the private route table with the private subnets
resource "aws_route_table_association" "private_route_table_association" {
  count          = var.PRIV_RT_DETAILS["rt_assc_count"]
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

#Creating a VPC S3 endpoint
resource "aws_vpc_endpoint" "s3_endpoint" {
 vpc_id       = aws_vpc.my_vpc.id
 service_name = var.VPC_ENDPOINT_DETAILS["service_name"]
 route_table_ids = [
    aws_route_table.private_route_table.id
  ]
 policy       = <<EOF
    {
       "Statement": [
        {
          "Action": "${var.VPC_ENDPOINT_DETAILS["policy_action"]}",
          "Effect": "${var.VPC_ENDPOINT_DETAILS["policy_effect"]}",
          "Resource": "${var.VPC_ENDPOINT_DETAILS["policy_resource"]}",
          "Principal": "${var.VPC_ENDPOINT_DETAILS["policy_principal"]}"
        }
      ]
    }
EOF

tags = {
    Name = var.VPC_ENDPOINT_DETAILS["name"]
  }
}
