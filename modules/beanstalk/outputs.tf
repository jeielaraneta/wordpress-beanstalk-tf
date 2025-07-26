output "demo_learning_environment" {
  value = aws_elastic_beanstalk_environment.demo_learning_environment
}

output "eb_hosted_zone" {
    value = data.aws_elastic_beanstalk_hosted_zone.eb_hosted_zone
}