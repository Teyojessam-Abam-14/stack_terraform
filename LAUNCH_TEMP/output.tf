output "master_launch_template_id"{
    value=aws_launch_template.master_lt.id
}

output "worker_launch_template_id"{
    value=aws_launch_template.worker_lt.id
}