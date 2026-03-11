locals {
  policy_attachments = {
    eks_cluster = toset([
      "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    ])
    eks_node_group = toset([
      "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
      "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
      "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    ])
  }
}
resource "aws_iam_role_policy_attachment" "eks_cluster_role_attachment" {
  for_each   = local.policy_attachments["eks_cluster"]
  policy_arn = each.value
  role       = aws_iam_role.roles["eks_cluster"].name
}

resource "aws_iam_role_policy_attachment" "eks_node_role_attachment" {
  for_each   = local.policy_attachments["eks_node_group"]
  policy_arn = each.value
  role       = aws_iam_role.roles["eks_node_group"].name
}