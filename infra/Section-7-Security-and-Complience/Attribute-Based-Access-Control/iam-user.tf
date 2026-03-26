resource "aws_iam_group" "devops" {
  name = "devops-group"
}

resource "aws_iam_user" "users" {
  for_each = local.users
  name     = each.value.name
  tags = {
    Team = each.value.team
  }
}

resource "aws_iam_user_group_membership" "membership" {
  for_each = local.users
  user     = aws_iam_user.users[each.key].name
  groups   = [aws_iam_group.devops.name]
}