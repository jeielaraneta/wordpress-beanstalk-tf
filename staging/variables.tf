variable "region" {}

variable "application_name" {}

variable "owner" {}

variable "environment" {}

variable "keypair" {}

variable "beanstalk_ec2_type" {}

variable "db_username" {}

variable "record_name" {
    description = "The sub-domain of the website in Route 53"
    type = string
}

variable "skip_rds_final_snapshot" {}

variable "number_of_selected_az" {}