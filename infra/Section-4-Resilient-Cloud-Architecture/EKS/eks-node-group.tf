resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.project_name}-node-group"
  node_role_arn   = aws_iam_role.roles["eks_node_group"].arn
  subnet_ids      = var.public_subnet_ids
  ami_type        = var.ami_type
  instance_types  = var.instance_type
  capacity_type   = var.capacity_type
  disk_size       = 20

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }
  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_node_role_attachment
  ]

  remote_access {
    ec2_ssh_key               = "terraform-key"
    source_security_group_ids = [aws_security_group.eks_node_group_ssh.id]
  }
}