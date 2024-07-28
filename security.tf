#Declaring security groups for public (Bastion) servers
resource "aws_security_group" "vpc-public-sg" {
  vpc_id      = module.VPC-BASE[0].vpc_id
  name        = "vpc-pub-sg-tf"
  description = "Stack IT Security Group For Bastion "

  tags = {
    Name        = "vpc-pub-sg-tf"
    Environment = "Production"
    OwnerEmail  = "teyojessam.abam@gmail.com"
    Sessions    = "StackCloud10"

  }
}

#SSH rule
resource "aws_security_group_rule" "ssh-vpc-pub" {
  security_group_id = aws_security_group.vpc-public-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}

#HTTP rule
resource "aws_security_group_rule" "http-vpc-pub" {
  security_group_id = aws_security_group.vpc-public-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

#HTTPS rule
resource "aws_security_group_rule" "https-vpc-pub" {
  security_group_id = aws_security_group.vpc-public-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}


#NFS rule
resource "aws_security_group_rule" "nfs-vpc-pub" {
  security_group_id = aws_security_group.vpc-public-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 2049
  to_port           = 2049
  cidr_blocks       = ["0.0.0.0/0"]
}

#MySQL rule
resource "aws_security_group_rule" "mySQL-vpc-pub" {
  security_group_id = aws_security_group.vpc-public-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 3306
  to_port           = 3306
  cidr_blocks       = ["0.0.0.0/0"]


}

#OracleDB rule
resource "aws_security_group_rule" "oracle-vpc-pub" {
  security_group_id = aws_security_group.vpc-public-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 1521
  to_port           = 1521
  cidr_blocks       = ["0.0.0.0/0"]


}

#Outbound rule
resource "aws_security_group_rule" "outbound-vpc-pub" {
  security_group_id = aws_security_group.vpc-public-sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]

}

###################################################################################################

#Declaring security groups for private (K8 App) servers
resource "aws_security_group" "vpc-web-sg" {
  vpc_id      = module.VPC-BASE[0].vpc_id
  name        = "vpc-web-sg-tf"
  description = "Stack IT Security Group For K8 App servers "

  tags = {
    Name        = "vpc-web-sg-tf"
    Environment = "Production"
    OwnerEmail  = "teyojessam.abam@gmail.com"
    Sessions    = "StackCloud10"

  }
}

#SSH rule (with source as the Public security group)
resource "aws_security_group_rule" "ssh-web" {
  security_group_id        = aws_security_group.vpc-web-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
  source_security_group_id = aws_security_group.vpc-public-sg.id

}

#HTTP rule (with source as the Public security group)
resource "aws_security_group_rule" "http-web" {
  security_group_id        = aws_security_group.vpc-web-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  source_security_group_id = aws_security_group.vpc-public-sg.id
}

#HTTPS rule (with source as the Public security group)
resource "aws_security_group_rule" "https-web" {
  security_group_id        = aws_security_group.vpc-web-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 443
  to_port                  = 443
  source_security_group_id = aws_security_group.vpc-public-sg.id
}


#NFS rule (with source as the Public security group)
resource "aws_security_group_rule" "nfs-web" {
  security_group_id        = aws_security_group.vpc-web-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 2049
  to_port                  = 2049
  source_security_group_id = aws_security_group.vpc-web-sg.id
}

#MySQL rule (with source as the Private (Database) security group)
resource "aws_security_group_rule" "mySQL-web" {
  security_group_id        = aws_security_group.vpc-web-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.vpc-db-sg.id
}

#Oracle rule (with source as the Private (Database) security group)
resource "aws_security_group_rule" "oracle-web" {
  security_group_id        = aws_security_group.vpc-web-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 1521
  to_port                  = 1521
  source_security_group_id = aws_security_group.vpc-db-sg.id
}

#K8 Security group rules as follows:
resource "aws_security_group_rule" "clixx_6443" {
  security_group_id        = aws_security_group.vpc-web-sg.id
  type                     = "ingress"
  from_port                = 6443
  to_port                  = 6443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.vpc-web-sg.id
}

resource "aws_security_group_rule" "clixx_ingress_6443_pub" {
  security_group_id        = aws_security_group.vpc-web-sg.id
  type                     = "ingress"
  from_port                = 6443
  to_port                  = 6443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.vpc-public-sg.id
}

resource "aws_security_group_rule" "clixx_p2p_weave" {
  security_group_id        = aws_security_group.vpc-web-sg.id
  type                     = "ingress"
  from_port                = 6783
  to_port                  = 6783
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.vpc-web-sg.id
}

resource "aws_security_group_rule" "clixx_p2p_weave_pub" {
  security_group_id        = aws_security_group.vpc-web-sg.id
  type                     = "ingress"
  from_port                = 6783
  to_port                  = 6783
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.vpc-public-sg.id
}

resource "aws_security_group_rule" "clixx_ingress_30000_32767_pub" {
  security_group_id        = aws_security_group.vpc-web-sg.id
  type                     = "ingress"
  from_port                = 30000
  to_port                  = 32767
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.vpc-public-sg.id
}


resource "aws_security_group_rule" "clixx_ingress_3306_pub" {
  security_group_id        = aws_security_group.vpc-web-sg.id
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.vpc-public-sg.id
}

resource "aws_security_group_rule" "clixx_ingress_10259" {
  security_group_id        = aws_security_group.vpc-web-sg.id
  type                     = "ingress"
  from_port                = 10259
  to_port                  = 10259
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.vpc-public-sg.id
}

resource "aws_security_group_rule" "clixx_ingress_9090" {
  security_group_id        = aws_security_group.vpc-web-sg.id
  type                     = "ingress"
  from_port                = 9090
  to_port                  = 9090
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.vpc-web-sg.id
}

resource "aws_security_group_rule" "clixx_ingress_10250" {
  security_group_id        = aws_security_group.vpc-web-sg.id
  type                     = "ingress"
  from_port                = 10250
  to_port                  = 10250
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.vpc-web-sg.id
}

resource "aws_security_group_rule" "clixx_ingress_10250_pub" {
  security_group_id        = aws_security_group.vpc-web-sg.id
  type                     = "ingress"
  from_port                = 10250
  to_port                  = 10250
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.vpc-public-sg.id
}

resource "aws_security_group_rule" "clixx_ingress_9093" {
  security_group_id        = aws_security_group.vpc-web-sg.id
  type                     = "ingress"
  from_port                = 9093
  to_port                  = 9093
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.vpc-web-sg.id
}

resource "aws_security_group_rule" "clixx_ingress_3000" {
  security_group_id        = aws_security_group.vpc-web-sg.id
  type                     = "ingress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.vpc-web-sg.id
}

resource "aws_security_group_rule" "clixx_ingress_2379_2380" {
  security_group_id        = aws_security_group.vpc-web-sg.id
  type                     = "ingress"
  from_port                = 2379
  to_port                  = 2380
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.vpc-web-sg.id
}

resource "aws_security_group_rule" "clixx_ingress_2379_2380_pub" {
  security_group_id        = aws_security_group.vpc-web-sg.id
  type                     = "ingress"
  from_port                = 2379
  to_port                  = 2380
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.vpc-public-sg.id
}

resource "aws_security_group_rule" "clixx_ingress_10257_priv" {
  security_group_id        = aws_security_group.vpc-web-sg.id
  type                     = "ingress"
  from_port                = 10257
  to_port                  = 10257
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.vpc-web-sg.id
}

resource "aws_security_group_rule" "clixx_ingress_8443" {
  security_group_id        = aws_security_group.vpc-web-sg.id
  type                     = "ingress"
  from_port                = 8443
  to_port                  = 8443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.vpc-public-sg.id
}

resource "aws_security_group_rule" "clixx_ingress_10257" {
  security_group_id        = aws_security_group.vpc-web-sg.id
  type                     = "ingress"
  from_port                = 10257
  to_port                  = 10257
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.vpc-public-sg.id
}

resource "aws_security_group_rule" "clixx_ingress_8080" {
  security_group_id        = aws_security_group.vpc-web-sg.id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.vpc-public-sg.id
}

resource "aws_security_group_rule" "clixx_ingress_6784" {
  security_group_id        = aws_security_group.vpc-web-sg.id
  type                     = "ingress"
  from_port                = 6784
  to_port                  = 6784
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.vpc-public-sg.id
}

resource "aws_security_group_rule" "clixx_ingress_1521" {
  security_group_id        = aws_security_group.vpc-web-sg.id
  type                     = "ingress"
  from_port                = 1521
  to_port                  = 1521
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.vpc-public-sg.id
}

resource "aws_security_group_rule" "clixx_ingress_22" {
  security_group_id = aws_security_group.vpc-web-sg.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

#Outbound rule
resource "aws_security_group_rule" "outbound-web" {
  security_group_id = aws_security_group.vpc-web-sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

############################################################################

#Declaring security groups for private (Database) servers
resource "aws_security_group" "vpc-db-sg" {
  vpc_id      = module.VPC-BASE[0].vpc_id
  name        = "vpc-db-sg-tf"
  description = "Stack IT Security Group For DB "

  tags = {
    Name        = "vpc-db-sg-tf"
    Environment = "Production"
    OwnerEmail  = "teyojessam.abam@gmail.com"
    Sessions    = "StackCloud10"

  }
}


#MySQL rule (with source as the Private (K8 App) security group)
resource "aws_security_group_rule" "mySQL-db" {
  security_group_id        = aws_security_group.vpc-db-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.vpc-web-sg.id


}

#OracleDB rule (with source as the Private (K8 App) security group)
resource "aws_security_group_rule" "oracle-db" {
  security_group_id        = aws_security_group.vpc-db-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 1521
  to_port                  = 1521
  source_security_group_id = aws_security_group.vpc-web-sg.id

}

#SSH rule (with source as the Private (App) security group)
resource "aws_security_group_rule" "ssh-db" {
  security_group_id        = aws_security_group.vpc-db-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
  source_security_group_id = aws_security_group.vpc-public-sg.id
}

#Outbound rule (with source as the Private (App) security group)
resource "aws_security_group_rule" "outbound-db-mysql" {
  security_group_id = aws_security_group.vpc-db-sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 3306
  to_port           = 3306
  source_security_group_id = aws_security_group.vpc-web-sg.id

}

#General outbound rule
resource "aws_security_group_rule" "outbound-db" {
  security_group_id = aws_security_group.vpc-db-sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]

}