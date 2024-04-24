#Declaring load balancer
resource "aws_lb" "stack-lb" {
  name               = var.lb_name
  internal           = var.LB_DETAILS["internal"]
  load_balancer_type = var.LB_DETAILS["load_balancer_type"]
  security_groups    = var.security_groups
  subnets            = var.subnet_ids
  enable_deletion_protection = var.LB_DETAILS["enable_deletion_protection"]
  enable_cross_zone_load_balancing = var.LB_DETAILS["enable_cross_zone_load_balancing"]
  #tags=var.required_tags[count.index]
}

#Declaring target group
resource "aws_lb_target_group" "stack-blog-tg" {
  name     = var.tg_name
  port     = var.TG_DETAILS["port"]
  protocol = var.TG_DETAILS["protocol"]
  vpc_id = var.vpc_id

  health_check {
    enabled             = var.HEALTH_CHECK_DETAILS["enabled"]
    healthy_threshold   = var.HEALTH_CHECK_DETAILS["healthy_threshold"]
    interval            = var.HEALTH_CHECK_DETAILS["interval"]
    matcher             = var.HEALTH_CHECK_DETAILS["matcher"]
    path                = var.HEALTH_CHECK_DETAILS["path"]
    port                = var.HEALTH_CHECK_DETAILS["port"]
    protocol            = var.HEALTH_CHECK_DETAILS["protocol"]
    timeout             = var.HEALTH_CHECK_DETAILS["timeout"]
    unhealthy_threshold = var.HEALTH_CHECK_DETAILS["unhealthy_threshold"]
  }
}

#Declaring listener for load balancer with target group
resource "aws_lb_listener" "blog-listener" {
  load_balancer_arn = aws_lb.stack-lb.arn
  port              = var.LISTEN_DETAILS["port"]
  protocol          = var.LISTEN_DETAILS["protocol"]
 
  default_action {
    type             = var.LISTEN_DETAILS["default_action_type"]
    target_group_arn = aws_lb_target_group.stack-blog-tg.arn
  }
}

#Declaring autoscaling group
resource "aws_autoscaling_group" "terraform_asg"{
  name = var.asg_name
  depends_on = [ 
    var.efs_mount_target,
    var.rds_restored_db
   ]

  launch_template {
    id      = var.launch_template_id
    version = var.ASG_DETAILS["launch_template_version"]
  }

  target_group_arns = [aws_lb_target_group.stack-blog-tg.arn]

  min_size = var.ASG_DETAILS["min_size"]
  max_size = var.ASG_DETAILS["max_size"]
  health_check_grace_period = var.ASG_DETAILS["health_check_grace_period"]
  health_check_type         = var.ASG_DETAILS["health_check_type"]
  desired_capacity          = var.ASG_DETAILS["desired_capacity"]
  vpc_zone_identifier = var.subnets
  
  #Tagged name for servers
  tag {
    key                 = "Name"
    value               = "Stack-Dev-Server-TF"
    propagate_at_launch = var.ASG_DETAILS["propagate_at_launch"]
  }    
}