variable "application_name" {
  type    = string
  default = "demo"
}
variable "Environment" {
  type    = string
  default = "dev"
}

variable "vpc_id" {
  type    = string
  default = "vpc-0c24e033b72681942"
}
variable "subnets" {
  type    = list(string)
  default = ["subnet-0f5d889694ba2857f", "subnet-02488ea8b4a8320b5", "subnet-090dacc77211ca1da"]
}
variable "publicrules" {
  type = list(object({
    port        = number
    proto       = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      port        = 80
      proto       = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 22
      proto       = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 3689
      proto       = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "internal" {
  default = "false"
}
variable "load_balancer_type" {
  default = "application"
}

variable "app1_ami_id" {
  default = "ami-087c17d1fe0178315"
}

variable "app1_instance_type" {
  default = "t2.micro"
}

variable "app1_key_name" {
  default = "tf"
}

variable "app2_ami_id" {
  default = "ami-087c17d1fe0178315"
}

variable "app2_instance_type" {
  default = "t2.micro"
}

variable "app2_key_name" {
  default = "tf"
}