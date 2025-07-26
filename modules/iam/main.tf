resource "aws_iam_policy" "elasticbeanstalk_statistics_policy" {
  name        = "${var.iam_prefix}-${var.env_name}-elasticbeanstalk-statistics-policy"
  path        = "/"

  policy = jsonencode(
        {
            Version = "2012-10-17"
            Statement = [
                {
                    Effect   = "Allow"
                    Action   = "elasticbeanstalk:PutInstanceStatistics"
                    Resource = "*"
                }
            ]
        }
    )
}

data "aws_iam_policy_document" "ec2_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "elasticbeanstalk_core" {
  name = "AWSElasticBeanstalkRoleCore"
}

data "aws_iam_policy" "ssm_core_policy" {
  name = "AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role" "elasticbeanstalk_ec2_assume_role" {
  name                = "${var.iam_prefix}-${var.env_name}-beanstalk-ec2-assume-role"
  assume_role_policy  = data.aws_iam_policy_document.ec2_assume_role_policy.json
  managed_policy_arns = [
    aws_iam_policy.elasticbeanstalk_statistics_policy.arn,
    data.aws_iam_policy.elasticbeanstalk_core.arn,
    data.aws_iam_policy.ssm_core_policy.arn
  ]
}

resource "aws_iam_instance_profile" "elasticbeanstalk_ec2_profile" {
  name = "${var.iam_prefix}-${var.env_name}-elasticbeanstalk-ec2-role"
  role = aws_iam_role.elasticbeanstalk_ec2_assume_role.name
}

resource "aws_iam_service_linked_role" "elasticbeanstalk_service_linked_role" {
  aws_service_name = "elasticbeanstalk.amazonaws.com"
}