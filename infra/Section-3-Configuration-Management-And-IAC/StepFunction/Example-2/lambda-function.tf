locals {
  lambda_dir = "${path.module}/lambda"
  common_tags = {
    project   = var.project_name
    ManagedBy = "Terraform"
  }

  lambdas = {
    validator = {
      source_file = "${local.lambda_dir}/validator.py"
      handler     = "validator.handler"
      role_key    = "lambda"
      env = {
        ADMIN_POLICY_ARN = var.admin_access_policy_arn
      }
    }
    request_approval = {
      source_file = "${local.lambda_dir}/request_approval.py"
      handler     = "request_approval.handler"
      role_key    = "lambda_request_approval"
      env = {
        SNS_TOPIC_ARN = aws_sns_topic.approval_notifications.arn
      }
    }

    approver = {
      source_file = "${local.lambda_dir}/approver.py"
      handler     = "approver.handler"
      role_key    = "lambda_approver"
      env         = {}
    }
    remediator = {
      source_file = "${local.lambda_dir}/remediator.py"
      handler     = "remediator.handler"
      role_key    = "lambda_remediator"
      env = {
        ADMIN_POLICY_ARN = var.admin_access_policy_arn
      }
    }
  }
}

data "archive_file" "lambda_zip" {
  for_each    = local.lambdas
  type        = "zip"
  source_file = each.value.source_file
  output_path = "${local.lambda_dir}/${each.key}.zip"
}

resource "aws_lambda_function" "lambda" {
  for_each         = local.lambdas
  function_name    = "${var.project_name}-${replace(each.key, "_", "-")}"
  role             = aws_iam_role.iam_roles[each.value.role_key].arn
  handler          = each.value.handler
  runtime          = var.python_version
  filename         = data.archive_file.lambda_zip[each.key].output_path
  source_code_hash = data.archive_file.lambda_zip[each.key].output_base64sha256

  dynamic "environment" {
    for_each = length(each.value.env) > 0 ? [1] : []
    content {
      variables = each.value.env
    }
  }
  tags = merge(local.common_tags, {
    component = "lambda"
    Name      = each.key
  })
}