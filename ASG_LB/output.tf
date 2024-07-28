output "lb_dns"{
    value=aws_lb.stack-k8-lb.dns_name
}