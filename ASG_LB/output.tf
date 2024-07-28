output "lb_dns"{
    value=aws_lb.stack-lb.dns_name
}

output "tg_arn"{
    value=aws_lb_target_group.stack-clixx-tg.arn
}