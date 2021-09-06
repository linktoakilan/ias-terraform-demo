resource "aws_lb_listener" "front_end" {
  load_balancer_arn = var.load_balancer_arn
  port              = var.listerner_port
  protocol          = var.listerner_protocol

  default_action {
    type             = var.default_action_type
    target_group_arn = var.default_targetgroup
  }
}