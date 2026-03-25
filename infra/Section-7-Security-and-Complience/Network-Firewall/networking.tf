locals {
  subnet_names = {
    firewall = {
      name = "firewall-subnet"
      cidr = var.public_subnet_cidrs[0]
      az   = "${var.aws_region}${var.az_names[0]}"
    }
    customer = {
      name = "customer-subnet"
      cidr = var.public_subnet_cidrs[1]
      az   = "${var.aws_region}${var.az_names[1]}"
    }
  }

  firewall_endpoints_by_az = {
    for s in aws_networkfirewall_firewall.project.firewall_status[0].sync_states :
    s.availability_zone => s.attachment[0].endpoint_id
  }
}
resource "aws_vpc" "project" {
  cidr_block = var.vpc_cidr
  tags = merge({
    "Name" = "project-vpc"
  }, var.default_tags)
}

resource "aws_subnet" "public" {
  for_each                = local.subnet_names
  vpc_id                  = aws_vpc.project.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true
  tags = merge({
    Name = each.value.name
    },
  var.default_tags)
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.project.id
  tags = merge({
    "Name" = "project-ig"
  }, var.default_tags)
}

resource "aws_networkfirewall_firewall" "project" {
  firewall_policy_arn      = aws_networkfirewall_firewall_policy.project.arn
  name                     = "Demo-Network-Firewall"
  vpc_id                   = aws_vpc.project.id
  subnet_change_protection = false
  delete_protection        = false
  subnet_mapping {
    subnet_id = aws_subnet.public["firewall"].id
  }
}

resource "aws_networkfirewall_firewall_policy" "project" {
  name = "Demo-Network-Firewall-Policy"

  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]

    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.domain_filter.arn
    }

    stateless_rule_group_reference {
      priority     = 1
      resource_arn = aws_networkfirewall_rule_group.ip_filter.arn
    }
  }
}

resource "aws_networkfirewall_rule_group" "domain_filter" {
  capacity = 5
  name     = "Domain-Filter"
  type     = "STATEFUL"
  rule_group {
    rules_source {
      rules_source_list {
        generated_rules_type = "DENYLIST"
        target_types         = ["TLS_SNI", "HTTP_HOST"]
        targets              = ["facebook.com", "x.com"]
      }
    }
  }
}

resource "aws_networkfirewall_rule_group" "ip_filter" {
  capacity = 5
  name     = "IP-Filter"
  type     = "STATELESS"
  rule_group {
    rules_source {
      stateless_rules_and_custom_actions {
        stateless_rule {
          priority = 1
          rule_definition {
            actions = ["aws:drop"]
            match_attributes {
              source {
                address_definition = "8.8.8.8/32"
              }
              destination {
                address_definition = "0.0.0.0/0"
              }
            }
          }
        }
      }
    }
  }
}