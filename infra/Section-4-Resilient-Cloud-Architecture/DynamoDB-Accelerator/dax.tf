resource "aws_dax_cluster" "dax" {
  cluster_name       = "${var.project_name}-cluster"
  iam_role_arn       = aws_iam_role.dax_role.arn
  node_type          = var.dax_node_type
  replication_factor = var.dax_replication_factor
  subnet_group_name  = aws_dax_subnet_group.dax_subnets.name
  security_group_ids = [aws_security_group.dax_sg.id]
  tags               = var.default_tags
}