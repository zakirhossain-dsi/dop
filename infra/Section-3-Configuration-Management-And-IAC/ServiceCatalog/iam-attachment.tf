locals {
  servicecatalog_policies = toset([
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AWSCloudFormationFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  ])
}

resource "aws_iam_policy_attachment" "alice_attach" {
  name       = "alice-attach"
  policy_arn = "arn:aws:iam::aws:policy/AWSServiceCatalogEndUserFullAccess"
  users      = [aws_iam_user.alice.name]
}

resource "aws_iam_role_policy_attachment" "servicecatalog_attach" {
  for_each   = local.servicecatalog_policies
  policy_arn = each.value
  role       = aws_iam_role.roles["servicecatalog"].name
}