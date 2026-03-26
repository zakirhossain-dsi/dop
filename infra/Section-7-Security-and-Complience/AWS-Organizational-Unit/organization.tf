resource "aws_organizations_organization" "org" {
  feature_set = "ALL"
  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY",
  ]
}

resource "aws_organizations_organizational_unit" "development" {
  name      = "Development"
  parent_id = aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_account" "sandbox" {
  parent_id = aws_organizations_organizational_unit.development.id
  email     = "zakir.mbstu.ict07+sandbox@gmail.com"
  name      = "Sandbox Account"
}

data "aws_iam_policy_document" "deny_s3_access_doc" {
  statement {
    effect    = "Deny"
    actions   = ["s3:*"]
    resources = ["*"]
  }
}

resource "aws_organizations_policy" "deny_s3_access" {
  name    = "DenyS3Access"
  content = data.aws_iam_policy_document.deny_s3_access_doc.json
}

resource "aws_organizations_policy_attachment" "deny_s3_access_attachment" {
  policy_id = aws_organizations_policy.deny_s3_access.id
  target_id = aws_organizations_organizational_unit.development.id
}