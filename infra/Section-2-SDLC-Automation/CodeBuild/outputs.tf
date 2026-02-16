output "artifact_bucket" {
  value = aws_s3_bucket.artifacts.bucket
}

output "codebuild_project_name" {
  value = aws_codebuild_project.maven_build.name
}
