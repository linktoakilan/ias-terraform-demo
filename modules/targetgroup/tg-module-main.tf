resource "aws_lb_target_group" "tg" {
  name     = var.application_name
  port     = var.targetport
  protocol = var.targetprotocol
  vpc_id   = var.vpc_id
  tags = {
    "Name" = var.application_name
    "Env"  = var.Environment
  }
}

