resource "aws_elastic_beanstalk_application" "dop_eb_app" {
  name        = "${var.project_name}-eb-app"
  description = "Dop practice EB application"
  region      = var.aws_region
  tags = {
    Name = "dop-practice-eb-app"
  }
  tags_all = {}
}

resource "aws_elastic_beanstalk_environment" "dop_eb_env_blue" {
  name                   = "${var.project_name}-eb-env-blue"
  description            = "Dop practice Elastic Beanstalk blue environment"
  application            = aws_elastic_beanstalk_application.dop_eb_app.name
  platform_arn           = var.platform_arn
  cname_prefix           = var.cname_prefix_blue_env
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
    namespace = "aws:ec2:instances"
    name      = "InstanceTypes"
    value     = "t2.micro,t3.micro"
  }
}

resource "aws_elastic_beanstalk_environment" "dop_eb_env_green" {
  name                   = "${var.project_name}-eb-env-green"
  description            = "Dop practice Elastic Beanstalk green environment"
  application            = aws_elastic_beanstalk_application.dop_eb_app.name
  platform_arn           = var.platform_arn
  cname_prefix           = var.cname_prefix_green_env
  poll_interval          = null
  region                 = var.aws_region
  tags                   = {}
  tags_all               = {}
  template_name          = null
  tier                   = var.tier
  wait_for_ready_timeout = null
  version_label          = aws_elastic_beanstalk_application_version.dop_eb_app_version.name

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
    namespace = "aws:ec2:instances"
    name      = "InstanceTypes"
    value     = "t2.micro,t3.micro"
  }
}

resource "aws_iam_instance_profile" "eb_instance_profile" {
  name = "${var.project_name}-eb-ec2-profile"
  role = aws_iam_role.roles["eb-ec2"].name
}

resource "aws_elastic_beanstalk_application_version" "dop_eb_app_version" {
  name        = var.version_label
  application = aws_elastic_beanstalk_application.dop_eb_app.name
  bucket      = aws_s3_bucket.eb_bundles.id
  key         = aws_s3_object.app_bundle.key
}