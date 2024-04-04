#Declaring security group for Blog
resource "aws_security_group" "stack-sg-main" {
  vpc_id = var.vpc_id
  name        = "stack_web_dmz_terraform"
  description = "Stack IT Security Group For Blog System"
  tags = {
    Name        = "stack_web_dmz_terraform"
    Environment = "Production"
    OwnerEmail  = "teyojessam.abam@gmail.com"
    Sessions   = "StackCloud10"
  }
  
}

#Declaring SSH rule
resource "aws_security_group_rule" "ssh" {
  security_group_id = aws_security_group.stack-sg-main.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}

#Declaring HTTP rule
resource "aws_security_group_rule" "http" {
  security_group_id = aws_security_group.stack-sg-main.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

#Declaring NFS rule 
resource "aws_security_group_rule" "nfs" {
  security_group_id = aws_security_group.stack-sg-main.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 2049
  to_port           = 2049
  cidr_blocks       = ["0.0.0.0/0"]
}

#Declaring mySQL rule
resource "aws_security_group_rule" "mySQL" {
  security_group_id = aws_security_group.stack-sg-main.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 3306
  to_port           = 3306
  cidr_blocks       = ["0.0.0.0/0"]
}

#Declaring outbound rule
resource "aws_security_group_rule" "outbound" {
  security_group_id = aws_security_group.stack-sg-main.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
 cidr_blocks       = ["0.0.0.0/0"]
}