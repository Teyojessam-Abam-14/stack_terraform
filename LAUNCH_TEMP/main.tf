#Declaring Launch template for Clixx K8 Master node
resource "aws_launch_template" "master_lt" {
  name                   = var.master_node_name
  vpc_security_group_ids = var.security_groups  #Private/Web SG
  user_data              = var.master_bootstrap_file
  image_id               = var.ami
  instance_type          = var.LT_DETAILS["master_instance_type"]
  key_name               = var.PRIVATE_KEY
  instance_initiated_shutdown_behavior = var.LT_DETAILS["instance_initiated_shutdown_behavior"]
     iam_instance_profile {
        name = var.LT_DETAILS["iam_instance_profile"]
     }

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
  
  tag_specifications {
    resource_type = var.LT_DETAILS["resource_type_tag"]
    tags = {
      Backup = var.LT_DETAILS["backup_tag"]
    }
  }

}

#Declaring Launch template for Clixx K8 Worker node
resource "aws_launch_template" "worker_lt" {
  name                   = var.worker_node_name
  vpc_security_group_ids = var.security_groups   #Private/Web SG
  user_data              = var.worker_bootstrap_file
  image_id               = var.ami
  instance_type          = var.LT_DETAILS["worker_instance_type"]
  key_name               = var.PRIVATE_KEY
  instance_initiated_shutdown_behavior = var.LT_DETAILS["instance_initiated_shutdown_behavior"]
     iam_instance_profile {
        name = var.LT_DETAILS["iam_instance_profile"]
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
  
  tag_specifications {
    resource_type =var.LT_DETAILS["resource_type_tag"]
    tags = {
      Backup = var.LT_DETAILS["backup_tag"]
    }
  }

}
