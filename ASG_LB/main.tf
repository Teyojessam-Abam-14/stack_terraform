#Declaring load balancer
resource "aws_lb" "stack-k8-lb" {
  name               = var.lb_name
  internal           = var.LB_DETAILS["internal"]
  load_balancer_type = var.LB_DETAILS["load_balancer_type"]
  security_groups    = var.security_groups  #Public SG
  subnets            = var.subnet_ids
  enable_deletion_protection = var.LB_DETAILS["enable_deletion_protection"]
  enable_cross_zone_load_balancing = var.LB_DETAILS["enable_cross_zone_load_balancing"]


  tags = {
    Name = var.lb_name
  }
}


#Declaring a Route53 record using an existing domain name and hosted zone
resource "aws_route53_record" "clixx_53_record" {
  zone_id = var.hosted_zone_id
  name    = var.domain_name
  type    = var.ROUTE53_DETAILS["record_type"]
  alias {
    name                   = aws_lb.stack-k8-lb.dns_name
    zone_id                = aws_lb.stack-k8-lb.zone_id
    evaluate_target_health = var.ROUTE53_DETAILS["evaluate_target_health"]
  }
}

#Declaring target group
resource "aws_lb_target_group" "stack-k8-clixx-tg" {
  name     = var.tg_name
  port     = var.TG_DETAILS["port"]
  protocol = var.TG_DETAILS["protocol"]
  vpc_id = var.vpc_id
  target_type = var.TG_DETAILS["target_type"]

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
resource "aws_lb_listener" "clixx-k8-listener" {
  load_balancer_arn = aws_lb.stack-k8-lb.arn
  port              = var.LISTEN_DETAILS["port"]
  protocol          = var.LISTEN_DETAILS["protocol"]

  default_action {
    type             = var.LISTEN_DETAILS["default_action_type"]
    target_group_arn = aws_lb_target_group.stack-k8-clixx-tg.arn
  }
}


#Declaring autoscaling group for K8 Master Node
resource "aws_autoscaling_group" "terraform_k8_master_asg"{
  name = var.k8_master_asg_name
  depends_on = [ 
    var.efs_mount_target,
    var.rds_restored_db
   ]

  launch_template {
    id      = var.master_launch_template_id
    version = var.ASG_DETAILS["launch_template_version"]
  }

  min_size = var.ASG_DETAILS["min_size_for_k8_master"]
  max_size = var.ASG_DETAILS["max_size_for_k8_master"]
  health_check_grace_period = var.ASG_DETAILS["health_check_grace_period"]
  health_check_type         = var.ASG_DETAILS["health_check_type"]
  desired_capacity          = var.ASG_DETAILS["desired_capacity_k8_master"]
  vpc_zone_identifier = [
    var.private_subnet_c,  # private_subnet_clixx_1a
    var.private_subnet_d   # private_subnet_clixx_1b
  ]
  
  #Tagged name for servers
  tag {
    key                 = var.ASG_DETAILS["instance_tag_key"]
    value               = var.ASG_DETAILS["master_node_tag_value"]
    propagate_at_launch = var.ASG_DETAILS["propagate_at_launch"]
  }    
}


#Declaring autoscaling group for K8 Worker Node
resource "aws_autoscaling_group" "terraform_k8_worker_asg"{
  name = var.k8_worker_asg_name
  depends_on = [ 
    var.efs_mount_target,
    var.rds_restored_db
   ]

  launch_template {
    id      = var.worker_launch_template_id
    version = var.ASG_DETAILS["launch_template_version"]
  }

  target_group_arns = [aws_lb_target_group.stack-k8-clixx-tg.arn]

  min_size = var.ASG_DETAILS["min_size_for_k8_worker"]
  max_size = var.ASG_DETAILS["max_size_for_k8_worker"]
  health_check_grace_period = var.ASG_DETAILS["health_check_grace_period"]
  health_check_type         = var.ASG_DETAILS["health_check_type"]
  desired_capacity          = var.ASG_DETAILS["desired_capacity_k8_worker"]
  vpc_zone_identifier = [
    var.private_subnet_c,  # private_subnet_clixx_1a
    var.private_subnet_d   # private_subnet_clixx_1b
  ]
  
  #Tagged name for servers
  tag {
    key                 = var.ASG_DETAILS["instance_tag_key"]
    value               = var.ASG_DETAILS["worker_node_tag_value"]
    propagate_at_launch = var.ASG_DETAILS["propagate_at_launch"]
  }    
}

