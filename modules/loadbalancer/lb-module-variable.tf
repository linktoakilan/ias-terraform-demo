variable "application_name" {}

variable "Environment" {}

variable "internal" {}

variable "load_balancer_type" {}

variable "security_groups" {}

variable "subnets" {
  type = list(string)
}