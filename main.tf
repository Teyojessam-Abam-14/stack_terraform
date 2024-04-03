#Declaring load balancer
resource "aws_lb" "stack-lb" {
  name               = "stack-lb-terraform"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.stack-sg-main.id]
  subnets            = var.subnet_ids
  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true

  tags = {
    Environment  = var.environment
    OwnerEmail   = var.OwnerEmail
  }
}

#Declaring target group
resource "aws_lb_target_group" "stack-clixx-tg" {
  name     = "Stack-ClIXX"
  port     = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 10
    matcher             = 200
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 3
    unhealthy_threshold = 3
  }
}

#Declaring an EFS file system
resource "aws_efs_file_system" "terraform_efs" {
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  tags = {
    Name = "terraform_efs"
  }
  
  encrypted = true
} 

#Declaring the created-EFS file system as a mount target
resource "aws_efs_mount_target" "terraform_efs_mount" {
  count           = length(var.subnet_ids)
  file_system_id = aws_efs_file_system.terraform_efs.id
  subnet_id   =  var.subnet_ids[count.index] 
  security_groups = [aws_security_group.stack-sg-main.id]
}

#Key pair for newly-deployed instances
resource "aws_key_pair" "Stack_KP" {
  key_name   = "stackkp"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

#Declaring listener for load balancer with target group
resource "aws_lb_listener" "clixx-listener" {
  load_balancer_arn = aws_lb.stack-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.stack-clixx-tg.arn
  }
}

#Declaring Launch template for Clixx
resource "aws_launch_template" "terraform_lt" {
  name                   = var.clixx_name
  vpc_security_group_ids = [aws_security_group.stack-sg-main.id]
  user_data              = base64encode(data.template_file.bootstrap.rendered)
  image_id               = data.aws_ami.stack_ami.id
  instance_type          = var.instance_type
  key_name = aws_key_pair.Stack_KP.key_name

#Declaring EBS Volumes
  block_device_mappings {
    device_name = "/dev/sdb"

    ebs {
     volume_type           = "gp2"
     volume_size           = 8
     delete_on_termination = true
    }
  }


  block_device_mappings {
    device_name = "/dev/sdc"

    ebs {
     volume_type           = "gp2"
     volume_size           = 8
     delete_on_termination = true
    }
  }


  block_device_mappings {
    device_name = "/dev/sdd"

    ebs {
     volume_type           = "gp2"
     volume_size           = 8
     delete_on_termination = true
    }
  }


  block_device_mappings {
    device_name = "/dev/sde"

    ebs {
     volume_type           = "gp2"
     volume_size           = 8
     delete_on_termination = true
    }
  }


  block_device_mappings {
    device_name = "/dev/sdg"

    ebs {
     volume_type           = "gp2"
     volume_size           = 8
     delete_on_termination = true
    }
  }

  tags = {
  Name = "Stack-Dev-Template-TF"
  Environment = var.environment
  OwnerEmail = var.OwnerEmail
}
}

#Declaring autoscaling group
resource "aws_autoscaling_group" "terraform_asg"{
  name = var.asg_name
  depends_on = [ 
    aws_efs_mount_target.terraform_efs_mount,
    aws_db_instance.restored_db
   ]

  launch_template {
    id      = aws_launch_template.terraform_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.stack-clixx-tg.arn]

  min_size = 2
  max_size = 4
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 4
  vpc_zone_identifier = data.aws_subnets.selected.ids

  tag {
    key                 = "Name"
    value               = "Stack-Dev-Server-TF"
    propagate_at_launch = true
  }    
}

