resource "aws_eks_cluster" "main" {
  name     = "${var.project_name}-cluster"
  role_arn = aws_iam_role.roles["eks_cluster"].arn
  version  = var.eks_cluster_version
  vpc_config {
    subnet_ids              = var.public_subnet_ids
    security_group_ids      = [aws_security_group.eks_sg.id]
    endpoint_public_access  = true
    endpoint_private_access = false
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_role_attachment
  ]
}