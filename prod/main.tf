terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

data "aws_availability_zones" "available" {
  all_availability_zones = true
  
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

provider "aws" {
  region  = var.region
}

locals {
  selected_azs = {
    "dev"   = [for i in range(var.number_of_selected_az): data.aws_availability_zones.available.names[i]]
    "staging" = [for i in range(var.number_of_selected_az): data.aws_availability_zones.available.names[i]]
    "prod"  = [for i in range(var.number_of_selected_az): data.aws_availability_zones.available.names[i]] #data.aws_availability_zones.available.names
  }
}

data "aws_caller_identity" "current" {}

module "iam" {
  source = "../modules/iam"

  iam_prefix          = var.application_name
  env_name            = var.environment
  account_id          = data.aws_caller_identity.current.account_id
}

module "vpc" {
  source = "../modules/vpc"

  vpc_prefix          = var.application_name
  env_name            = var.environment
  vpc_cidr            = "173.168.0.0/16"
  availability_zones  = local.selected_azs[var.environment]
}

module "secrets_manager" {
  source      = "../modules/secrets_manager"
  prefix      = var.application_name
  env_name    = var.environment
  db_username = var.db_username
}

module "rds" {
  source                  = "../modules/rds"
  db_prefix               = var.application_name
  env_name                = var.environment
  subnet_group_name       = module.vpc.rds_subnet_group
  security_group_id       = module.vpc.rds_security_group_id
  rds_secrets             = module.secrets_manager.rds_secrets
  skip_rds_final_snapshot = var.skip_rds_final_snapshot
  depends_on              = [module.vpc]
  availability_zones      = local.selected_azs[var.environment]
}

module "beanstalk" {
  source              = "../modules/beanstalk"
  beanstalk_prefix    = var.application_name
  env_name            = var.environment
  vpc_id              = module.vpc.vpc_id
  ec2_subnets         = module.vpc.private_subnets
  alb_subnets         = module.vpc.public_subnets
  keypair             = var.keypair
  beanstalk_ec2_type  = var.beanstalk_ec2_type
  beanstalk_ec2_role  = module.iam.elasticbeanstalk_ec2_profile.arn
  beanstalk_service_role  = module.iam.elasticbeanstalk_service_linked_role.arn
  depends_on          = [module.vpc]
}

module "route_53" {
  source          = "../modules/route_53"
  eb_env          = module.beanstalk.demo_learning_environment
  eb_hosted_zone  = module.beanstalk.eb_hosted_zone
  record_name     = var.record_name
  depends_on      = [module.beanstalk.demo_learning_environment]
}