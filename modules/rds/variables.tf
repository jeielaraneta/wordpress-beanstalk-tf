variable "db_prefix" {
    description = "Abbreviation of the client company's name. Example: ccst"
    type        = string
}

variable "env_name" {
    description = "Name of the environment"
    type        = string
}

variable "subnet_group_name" {
    type = string
}

variable "security_group_id" {
    type = string
}

variable "rds_secrets" {}

variable "skip_rds_final_snapshot" {}

variable "availability_zones" {}