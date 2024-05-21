resource "aws_key_pair" "Stack_KP" {
  key_name   = "stackkp_vpc"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "bastion_hosts" {
 count = length(var.subnets)  //counts all the available subnet ids
 subnet_id     = var.subnets[count.index] //Create an EC2 Instance for each subnet id
 ami           = var.ami 
 instance_type          = var.EC2_DETAILS["instance_type"]
 vpc_security_group_ids = var.security_groups
 user_data = var.bootstrap_file
 iam_instance_profile = var.s3_access
 key_name = aws_key_pair.Stack_KP.key_name
 availability_zone = var.availability_zones[count.index]
 associate_public_ip_address = var.EC2_DETAILS["associate_public_ip"]

 root_block_device {
   volume_type           = var.EC2_DETAILS["volume_type"]
   volume_size           = var.EC2_DETAILS["volume_size"]
   delete_on_termination = var.EC2_DETAILS["delete_on_termination"]
   encrypted= var.EC2_DETAILS["encrypted"]
 }
 

    tags = {
    Name  = "bastion-host${count.index + 1}"
    }
  #tags=var.required_tags[count.index]
}