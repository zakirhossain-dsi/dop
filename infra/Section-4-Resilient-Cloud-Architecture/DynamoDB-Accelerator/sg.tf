resource "aws_security_group" "dax_sg" {
  name        = "${var.project_name}-dax-sg"
  description = "Allow application access to DAX"
  vpc_id      = var.vpc_id

  ingress {
    description = "App to DAX"
    from_port   = 8111
    to_port     = 8111
    protocol    = "tcp"
    cidr_blocks = var.app_cidrs
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.default_tags
}

resource "aws_dax_subnet_group" "dax_subnets" {
  name       = "${var.project_name}-dax-subnet-group"
  subnet_ids = var.subnet_ids
}