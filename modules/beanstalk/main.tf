resource "aws_elastic_beanstalk_application" "demo_learning_application" {
  name        = "${var.beanstalk_prefix}-${var.env_name}-beanstalk-app"
}

resource "aws_elastic_beanstalk_environment" "demo_learning_environment" {
  name                = "${var.beanstalk_prefix}-${var.env_name}-beanstalk-env"
  application         = aws_elastic_beanstalk_application.demo_learning_application.name
  solution_stack_name = "64bit Amazon Linux 2 v3.5.2 running PHP 8.1"
  tier                = "WebServer"
 
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", var.ec2_subnets)
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = join(",", var.alb_subnets)
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     =  var.beanstalk_ec2_role
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = var.beanstalk_service_role
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.beanstalk_ec2_type
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = var.keypair
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "internet facing"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = 1
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = 2
  }
}

data "aws_elastic_beanstalk_hosted_zone" "eb_hosted_zone" {}

