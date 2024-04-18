resource "aws_key_pair" "Stack_KP" {
  key_name   = "stackkp"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "Server" {
 count = length(var.subnets)  //counts all the available subnets
 subnet_id     = var.subnets[count.index] //Create an EC2 Instance for each subnet
 ami           = var.ami 
 instance_type          = var.EC2_DETAILS["instance_type"]
 vpc_security_group_ids = var.security_groups
 user_data = var.bootstrap_file
 key_name = aws_key_pair.Stack_KP.key_name

 root_block_device {
   volume_type           = var.EC2_DETAILS["volume_type"]
   volume_size           = var.EC2_DETAILS["volume_size"]
   delete_on_termination = var.EC2_DETAILS["delete_on_termination"]
   encrypted= var.EC2_DETAILS["encrypted"]
 }
 
  #tags=var.required_tags[count.index]
}