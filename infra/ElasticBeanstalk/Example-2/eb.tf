resource "aws_elastic_beanstalk_application" "dop_eb_app" {
  name        = "${var.project_name}-eb-app"
  description = "Dop practice EB application"
  region      = var.aws_region
  tags = {
    Name = "dop-practice-eb-app"
  }
  tags_all = {}
}

resource "aws_elastic_beanstalk_environment" "dop_eb_env" {
  name                   = "${var.project_name}-eb-env"
  description            = "Dop practice EB environment"
  application            = aws_elastic_beanstalk_application.dop_eb_app.name
  platform_arn           = var.platform_arn
  cname_prefix           = var.cname_prefix
  poll_interval          = null
  region                 = var.aws_region
  tags                   = {}
  tags_all               = {}
  template_name          = null
  tier                   = var.tier
  wait_for_ready_timeout = null

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.roles["eb-service"].name
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_instance_profile.name
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "2"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "4"
  }
  setting {
    namespace = "aws:ec2:instances"
    name      = "InstanceTypes"
    value     = "t2.micro,t3.micro"
  }
}

resource "aws_iam_instance_profile" "eb_instance_profile" {
  name = "${var.project_name}-eb-ec2-profile"
  role = aws_iam_role.roles["eb-ec2"].name
}