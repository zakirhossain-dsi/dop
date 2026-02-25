resource "aws_servicecatalog_product" "dev_env" {
  name        = "${var.project_name}-dev-env"
  type        = "CLOUD_FORMATION_TEMPLATE"
  owner       = "Security Team"
  description = "This is a product for creating dev environment"
  provisioning_artifact_parameters {
    template_url = local.template_url
    type         = "CLOUD_FORMATION_TEMPLATE"
  }
  tags = {
    Project = var.project_name
  }
}

resource "aws_servicecatalog_portfolio" "dev_portfolio" {
  name          = "${var.project_name}-dev-portfolio"
  description   = "Portfolio for demo products"
  provider_name = "Security Team"
  tags = {
    Project = var.project_name
  }
}

resource "aws_servicecatalog_product_portfolio_association" "dev_product_portfolio_association" {
  portfolio_id = aws_servicecatalog_portfolio.dev_portfolio.id
  product_id   = aws_servicecatalog_product.dev_env.id
}

resource "aws_servicecatalog_principal_portfolio_association" "dev_principal_portfolio_association" {
  portfolio_id   = aws_servicecatalog_portfolio.dev_portfolio.id
  principal_arn  = aws_iam_user.alice.arn
  principal_type = "IAM"
}

resource "aws_servicecatalog_constraint" "launch_constraint" {
  portfolio_id = aws_servicecatalog_portfolio.dev_portfolio.id
  product_id   = aws_servicecatalog_product.dev_env.id
  type         = "LAUNCH"
  parameters = jsonencode({
    RoleArn = aws_iam_role.roles["servicecatalog"].arn
  })
}