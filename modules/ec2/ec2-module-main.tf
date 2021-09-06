resource "aws_instance" "ec2" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  security_groups = var.security_groups
  subnet_id       = var.subnet_id
  key_name        = var.key_name
  iam_instance_profile = var.iam_instance_profile
  tags = {
    "Name" = var.application_name
    "Env"  = var.Environment
  }
}