resource "aws_codeartifact_domain" "ca_domain" {
  domain = var.code_artifact_domain
  tags = {
    Name = "${var.project_name}-domain"
  }
}

resource "aws_codeartifact_repository" "pypi_store" {
  repository = "pypi-store"
  domain     = aws_codeartifact_domain.ca_domain.domain
  external_connections {
    external_connection_name = "public:pypi"
  }
}

resource "aws_codeartifact_repository" "ca_repository" {
  repository = "${var.project_name}-repo"
  domain     = aws_codeartifact_domain.ca_domain.domain
  tags = {
    Name = "${var.project_name}-repo"
  }

  upstream {
    repository_name = aws_codeartifact_repository.pypi_store.repository
  }
}