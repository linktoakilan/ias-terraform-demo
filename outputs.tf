output "load_balancer_dns" {
  value = module.publicloadbalancer.lb_dns_name
}
output "Appserver1_public_ip" {
  value = module.appserver1.aws_instance_publicip
}
output "Appserver2_public_ip" {
  value = module.appserver2.aws_instance_publicip
}
