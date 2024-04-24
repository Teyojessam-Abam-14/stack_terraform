#Declaring key pair with public key
resource "aws_key_pair" "Stack_KP" {
  key_name   = "stackkp"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

#Declaring Launch template for Blog
resource "aws_launch_template" "terraform_lt" {
  name                   = var.blog_name
  vpc_security_group_ids = var.security_groups
  user_data              = var.bootstrap_file
  image_id               = var.ami 
  instance_type          = var.LT_DETAILS["instance_type"]
  key_name = aws_key_pair.Stack_KP.key_name

#Declaring EBS Volumes
  block_device_mappings {
    device_name = var.EBS_DEVICES["B"]

    ebs {
     volume_type           = var.LT_DETAILS["volume_type"]
     volume_size           = var.LT_DETAILS["volume_size"]
     delete_on_termination = var.LT_DETAILS["delete_on_termination"]
    }
  }


  block_device_mappings {
    device_name = var.EBS_DEVICES["C"]

    ebs {
     volume_type           = var.LT_DETAILS["volume_type"]
     volume_size           = var.LT_DETAILS["volume_size"]
     delete_on_termination = var.LT_DETAILS["delete_on_termination"]
    }
  }


  block_device_mappings {
    device_name = var.EBS_DEVICES["D"]

    ebs {
     volume_type           = var.LT_DETAILS["volume_type"]
     volume_size           = var.LT_DETAILS["volume_size"]
     delete_on_termination = var.LT_DETAILS["delete_on_termination"]
    }
  }


  block_device_mappings {
    device_name = var.EBS_DEVICES["E"]

    ebs {
     volume_type           = var.LT_DETAILS["volume_type"]
     volume_size           = var.LT_DETAILS["volume_size"]
     delete_on_termination = var.LT_DETAILS["delete_on_termination"]
    }
  }


  block_device_mappings {
    device_name = var.EBS_DEVICES["G"]

    ebs {
     volume_type           = var.LT_DETAILS["volume_type"]
     volume_size           = var.LT_DETAILS["volume_size"]
     delete_on_termination = var.LT_DETAILS["delete_on_termination"]
    }
  }

  #tags=var.required_tags[count.index]
}
