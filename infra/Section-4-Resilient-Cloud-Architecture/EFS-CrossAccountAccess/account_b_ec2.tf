resource "aws_instance" "efs_client" {
  provider                    = aws.account_b
  ami                         = var.account_b_ec2_image_id
  instance_type               = var.account_b_ec2_instance_type
  subnet_id                   = aws_subnet.account_b_public[0].id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.efs_client_profile.name
  associate_public_ip_address = true
  user_data                   = <<-EOF
                              #!/bin/bash
                              set -eux
                              dnf update -y
                              dnf install -y amazon-efs-utils awscli nfs-utils python3-botocore

                              mkdir -p /root/.aws
                              cat > /root/.aws/config <<CONFIG
                              [profile efs-cross]
                              role_arn = ${aws_iam_role.efs_access_role.arn}
                              credential_source = Ec2InstanceMetadata
                              region = ${var.account_b_aws_region}
                              CONFIG

                              mkdir -p /shared-storage

                              # Manual resolution for cross-account / cross-VPC mount
                              echo "${local.selected_mount_target_ip} ${local.efs_dns_name}" >> /etc/hosts

                              # Mount using IAM authorization
                              mount -t efs -o tls,iam,awsprofile=efs-cross ${aws_efs_file_system.shared.id}:/ /shared-storage

                              # Simple test
                              echo "mounted from $(hostname)" > /shared-storage/hello.txt
                              EOF

  tags = merge({
    Name = "efs-client"
  }, var.default_tags)

  depends_on = [
    aws_vpc_peering_connection_accepter.b_accepts,
    aws_route.account_a_to_b,
    aws_route.account_b_to_a,
    aws_efs_mount_target.mt,
    aws_efs_file_system_policy.efs_policy
  ]
}

resource "aws_iam_instance_profile" "efs_client_profile" {
  provider = aws.account_b
  name     = "efs-client-profile"
  role     = aws_iam_role.ec2_role.name
}