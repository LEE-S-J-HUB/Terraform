
output "aws_lb_alb" {
    value = module.aws_lb.aws_lb_alb
}

output "aws_lb_nlb" {
    value = module.aws_lb.aws_lb_nlb
}

output "aws_lb_alb_dns" {
    value = { for k, dns in module.aws_lb.aws_lb_alb : k => dns.dns_name}
}

output "aws_lb_nlb_dns" {
    value = { for k, dns in module.aws_lb.aws_lb_nlb : k => dns.dns_name}
}