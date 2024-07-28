resource "aws_ecs_cluster" "ecs" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "ecs_taskdef" {
  family                   = var.TASK_DEF_DETAILS["family"]
  requires_compatibilities = [var.TASK_DEF_DETAILS["requires_compatibilities"]]
  execution_role_arn       = var.TASK_DEF_DETAILS["task_execution_role_arn"]
  task_role_arn            = var.TASK_DEF_DETAILS["task_execution_role_arn"]

  container_definitions = jsonencode([
    {
      name         = var.container_name
      image        = var.container_image
      essential    = var.container_essential
      memory       = var.CONT_MEMORY_PORT_MAP_DETAILS["container_memory"]
      network_mode = var.TASK_DEF_DETAILS["container_network_mode"]
      portMappings = [
        {
          containerPort = var.CONT_MEMORY_PORT_MAP_DETAILS["container_port"]
          hostPort      = var.CONT_MEMORY_PORT_MAP_DETAILS["host_port"]
          protocol      = var.TASK_DEF_DETAILS["protocol"]
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "ecs_service" {
  name                 = var.SERVICE_DETAILS["name"]
  cluster              = aws_ecs_cluster.ecs.id
  task_definition      = aws_ecs_task_definition.ecs_taskdef.arn
  desired_count        = var.SERVICE_DETAILS["desired_count"]
  launch_type          = var.SERVICE_DETAILS["launch_type"]
  force_new_deployment = var.SERVICE_DETAILS["force_new_deployment"]

  deployment_circuit_breaker {
    enable   = var.SERVICE_DETAILS["deployment_circuit_breaker_enable"]
    rollback = var.SERVICE_DETAILS["deployment_circuit_breaker_rollback"]
  }


  load_balancer {
    target_group_arn = var.tg_arn
    container_name   = var.container_name
    container_port   = var.CONT_MEMORY_PORT_MAP_DETAILS["container_port"]
  }
}
