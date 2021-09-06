# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "newgoodplace"
    key    = "demo/terraform-backend/"
    region = "us-east-2"
  }
}
module "publicsecuritygroup" {
  source           = "./modules/securitygroup"
  application_name = join("-", [var.application_name, "public", "sg"])
  Environment      = var.Environment
  vpc_id           = var.vpc_id
  rules            = var.publicrules
}
module "publicloadbalancer" {
  source             = "./modules/loadbalancer"
  application_name   = join("-", [var.application_name, "public", "alb"])
  Environment        = var.Environment
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = [module.publicsecuritygroup.sg_id]
  subnets            = var.subnets
}

module "appserver1" {
  source           = "./modules/ec2"
  application_name = join("-", [var.application_name, "app1"])
  Environment      = var.Environment
  ami_id           = var.app1_ami_id
  instance_type    = var.app1_instance_type
  security_groups  = [module.publicsecuritygroup.sg_id]
  subnet_id        = var.subnets[0]
  key_name         = var.app1_key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
}

module "appserver2" {
  source           = "./modules/ec2"
  application_name = join("-", [var.application_name, "app2"])
  Environment      = var.Environment
  ami_id = var.app2_ami_id
  instance_type = var.app2_instance_type
  security_groups = [module.publicsecuritygroup.sg_id]
  subnet_id = var.subnets[1]
  key_name = var.app2_key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
}

module "targetgroup1" {
  source           = "./modules/targetgroup"
  application_name = join("-", [var.application_name, "targetgroup1"])
  Environment      = var.Environment
  targetport       = "8080"
  targetprotocol   = "HTTP"
  vpc_id           = var.vpc_id
}

module "targetregistration1" {
  source = "./modules/targetregistration"

  target_group_arn = module.targetgroup1.aws_lb_tg_id
  target_id        = module.appserver1.aws_instance_id
  port             = "8080"
}
module "targetregistration2" {
  source = "./modules/targetregistration"

  target_group_arn = module.targetgroup1.aws_lb_tg_id
  target_id        = module.appserver2.aws_instance_id
  port             = "8080"
}
module "listenercreation1" {
  source              = "./modules/loadbalancerlistener"
  load_balancer_arn   = module.publicloadbalancer.lb_id
  listerner_port      = "80"
  listerner_protocol  = "HTTP"
  default_action_type = "forward"
  default_targetgroup = module.targetgroup1.aws_lb_tg_id
}

####################################################################################################################
resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = "${aws_iam_role.ec2_role.name}"
}

resource "aws_iam_role_policy" "ec2_policy" {
  name = "ec2_policy"
  role = "${aws_iam_role.ec2_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
    }
  ]
}
EOF
}