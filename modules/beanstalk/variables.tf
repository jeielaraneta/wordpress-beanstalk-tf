variable "beanstalk_prefix" {
    description = "Abbreviation of the client company's name. Example: ccst"
    type = string
}

variable "env_name" {
    description = "Name of the environment"
    type = string
}

variable "vpc_id" {
    description = "VPC ID"
    type = string
}

variable "ec2_subnets" {
    description = "Subnets for ec2 instances"
    type = list
}

variable "alb_subnets" {
    description = "Subnets for Load balancers"
    type = list
}
variable "keypair" {
    type = string
}

variable "beanstalk_ec2_type" {
    type = string
}
variable "beanstalk_ec2_role" {
    type = string
}
variable "beanstalk_service_role" {
    type = string
}