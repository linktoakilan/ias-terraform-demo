
resource "aws_lb" "lb" {
  name               = var.application_name
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = var.security_groups
  subnets            = var.subnets
  tags = {
    "Name" = var.application_name
    "Env"  = var.Environment
  }
}