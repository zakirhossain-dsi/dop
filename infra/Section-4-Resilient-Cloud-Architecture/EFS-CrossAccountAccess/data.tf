data "aws_caller_identity" "account_a" {
  provider = aws.account_a
}

data "aws_availability_zones" "account_a" {
  provider = aws.account_a
  state    = "available"
}

data "aws_caller_identity" "account_b" {
  provider = aws.account_b
}

data "aws_availability_zones" "account_b" {
  provider = aws.account_b
  state    = "available"
}

locals {
  # Use first 2 AZz
  account_a_az_names = slice(data.aws_availability_zones.account_a.names, 0, 2)
  account_a_az_ids   = slice(data.aws_availability_zones.account_a.zone_ids, 0, 2)

  account_b_az_names = slice(data.aws_availability_zones.account_b.names, 0, 2)
  account_b_az_ids   = slice(data.aws_availability_zones.account_b.zone_ids, 0, 2)

  # Map AZ name to AZ ID in each account
  account_a_az_map = zipmap(local.account_a_az_names, local.account_a_az_ids)
  account_b_az_map = zipmap(local.account_b_az_names, local.account_b_az_ids)

  ec2_subnet_az_name = aws_subnet.account_b_public[0].availability_zone
  ec2_subnet_az_id   = local.account_b_az_map[local.ec2_subnet_az_name]

  efs_mount_target_zone_ids = {
    for idx, mt in aws_efs_mount_target.mt :
    idx => local.account_a_az_map[aws_subnet.account_a_public[idx].availability_zone]
  }

  selected_mount_target_index = [
    for idx, zid in local.efs_mount_target_zone_ids : idx if zid == local.ec2_subnet_az_id
  ][0]

  selected_mount_target_ip = aws_efs_mount_target.mt[local.selected_mount_target_index].ip_address

  efs_dns_name = "${aws_efs_file_system.shared.id}.efs.${var.account_a_aws_region}.amazonaws.com"
}