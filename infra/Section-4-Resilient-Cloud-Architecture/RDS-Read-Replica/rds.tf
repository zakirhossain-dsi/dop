resource "aws_db_instance" "app_db" {
  identifier              = "${var.project_name}-db"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp3"
  parameter_group_name    = "default.mysql8.0"
  backup_retention_period = 7
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  skip_final_snapshot     = true

  tags = {
    Project = var.project_name
  }
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]
}

resource "aws_db_instance" "read_replica" {
  identifier                 = "${var.project_name}-read-replica"
  replicate_source_db        = aws_db_instance.app_db.identifier
  engine                     = aws_db_instance.app_db.engine
  instance_class             = aws_db_instance.app_db.instance_class
  auto_minor_version_upgrade = true
  apply_immediately          = true
  #  backup_retention_period    = 1
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]
  depends_on             = [aws_db_instance.app_db]
  skip_final_snapshot    = true
  tags = {
    Project = var.project_name
  }
}

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