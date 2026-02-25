resource "aws_rds_cluster" "db" {
  cluster_identifier              = "${var.project_name}-db"
  engine                          = var.db_engine
  engine_version                  = var.db_engine_version
  db_cluster_instance_class       = var.db_cluster_instance_class
  allocated_storage               = 20
  storage_type                    = "gp3"
  db_cluster_parameter_group_name = "default.mysql8.0"
  backup_retention_period         = 7
  master_username                 = var.db_master_username
  master_password                 = var.db_master_password
  skip_final_snapshot             = true
  tags = {
    Project = var.project_name
  }
  vpc_security_group_ids          = [aws_security_group.mysql_sg.id]
  enabled_cloudwatch_logs_exports = ["error", "general", "slowquery"]
}

/*resource "aws_rds_cluster_instance" "db_instances" {
  count               = 3
  identifier          = "${var.project_name}-db-instance-${count.index + 1}"
  cluster_identifier  = aws_rds_cluster.db.id
  instance_class      = var.db_instance_class
  engine              = aws_rds_cluster.db.engine
  publicly_accessible = false
}*/

resource "aws_security_group" "mysql_sg" {
  name        = "${var.project_name}-mysql-sg"
  description = "Allow MySQL access"
  tags = {
    Project = var.project_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "mysql_access_rule" {
  security_group_id            = aws_security_group.mysql_sg.id
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.app_server_sg.id
}

resource "aws_vpc_security_group_egress_rule" "mysql_egress_rule" {
  security_group_id = aws_security_group.mysql_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = var.all_ipv4
}