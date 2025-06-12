resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id
  tags        = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_with_ports" {
  count = length(var.ingress_with_ports)

  security_group_id = aws_security_group.this.id

  cidr_ipv4                    = lookup(var.ingress_with_ports[count.index], "cidr_ipv4", null)
  description                  = lookup(var.ingress_with_ports[count.index], "description", null)
  from_port                    = lookup(var.ingress_with_ports[count.index], "from_port", null)
  to_port                      = lookup(var.ingress_with_ports[count.index], "to_port", null)
  ip_protocol                  = lookup(var.ingress_with_ports[count.index], "ip_protocol", null)
  prefix_list_id               = lookup(var.ingress_with_ports[count.index], "prefix_list_id", null)
  referenced_security_group_id = lookup(var.ingress_with_ports[count.index], "referenced_security_group_id", null)
}

resource "aws_vpc_security_group_egress_rule" "egress_with_ports" {
  count = length(var.egress_with_ports)

  security_group_id = aws_security_group.this.id

  cidr_ipv4                    = lookup(var.egress_with_ports[count.index], "cidr_ipv4", null)
  description                  = lookup(var.egress_with_ports[count.index], "description", null)
  from_port                    = lookup(var.egress_with_ports[count.index], "from_port", null)
  to_port                      = lookup(var.egress_with_ports[count.index], "to_port", null)
  ip_protocol                  = lookup(var.egress_with_ports[count.index], "ip_protocol", null)
  prefix_list_id               = lookup(var.egress_with_ports[count.index], "prefix_list_id", null)
  referenced_security_group_id = lookup(var.egress_with_ports[count.index], "referenced_security_group_id", null)
}

resource "aws_vpc_security_group_egress_rule" "egress_all_traffic" {
  count = length(var.egress_all_traffic)

  security_group_id = aws_security_group.this.id

  cidr_ipv4                    = lookup(var.egress_all_traffic[count.index], "cidr_ipv4", null)
  description                  = lookup(var.egress_all_traffic[count.index], "description", null)
  ip_protocol                  = "-1"
  prefix_list_id               = lookup(var.egress_all_traffic[count.index], "prefix_list_id", null)
  referenced_security_group_id = lookup(var.egress_all_traffic[count.index], "referenced_security_group_id", null)

}




























# locals {
#   # Filter ingress rules based on protocol
#   ingress_rules_with_ports = [
#     for rule in var.ingress_rules : rule if rule.protocol != "-1"
#   ]

#   ingress_rules_without_ports = [
#     for rule in var.ingress_rules : rule if rule.protocol == "-1"
#   ]

#   # Filter egress rules based on protocol
#   egress_rules_with_ports = [
#     for rule in var.egress_rules : rule if rule.protocol != "-1"
#   ]

#   egress_rules_without_ports = [
#     for rule in var.egress_rules : rule if rule.protocol == "-1"
#   ]

#   # Filter rules with prefix lists
#   ingress_rules_with_prefix_lists = [
#     for rule in var.ingress_rules : rule if rule.prefix_list_ids != null
#   ]

#   egress_rules_with_prefix_lists = [
#     for rule in var.egress_rules : rule if rule.prefix_list_ids != null
#   ]

#   # Filter rules without prefix lists
#   ingress_rules_without_prefix_lists = [
#     for rule in var.ingress_rules : rule if rule.prefix_list_ids == null
#   ]

#   egress_rules_without_prefix_lists = [
#     for rule in var.egress_rules : rule if rule.prefix_list_ids == null
#   ]
# }

# # Use aws_security_group_rule for rules with prefix lists
# resource "aws_vpc_security_group_ingress_rule" "ingress_with_prefix_lists" {
#   count = length(local.ingress_rules_with_prefix_lists)

#   security_group_id = aws_security_group.this.id
#   description       = lookup(local.ingress_rules_with_prefix_lists[count.index], "description", null)

#   from_port   = local.ingress_rules_with_prefix_lists[count.index].protocol == "-1" ? 0 : local.ingress_rules_with_prefix_lists[count.index].from_port
#   to_port     = local.ingress_rules_with_prefix_lists[count.index].protocol == "-1" ? 0 : local.ingress_rules_with_prefix_lists[count.index].to_port
#   ip_protocol = local.ingress_rules_with_prefix_lists[count.index].protocol

#   cidr_ipv4                    = lookup(local.ingress_rules_with_prefix_lists[count.index], "cidr_blocks", null) != null ? [local.ingress_rules_with_prefix_lists[count.index].cidr_blocks] : null
#   referenced_security_group_id = lookup(local.ingress_rules_with_prefix_lists[count.index], "source_security_group_id", null)
#   prefix_list_id               = local.ingress_rules_with_prefix_lists[count.index].prefix_list_ids
# }

# resource "aws_vpc_security_group_egress_rule" "egress_with_prefix_lists" {
#   count = length(local.egress_rules_with_prefix_lists)

#   security_group_id = aws_security_group.this.id
#   description       = lookup(local.egress_rules_with_prefix_lists[count.index], "description", null)

#   from_port   = local.egress_rules_with_prefix_lists[count.index].protocol == "-1" ? 0 : local.egress_rules_with_prefix_lists[count.index].from_port
#   to_port     = local.egress_rules_with_prefix_lists[count.index].protocol == "-1" ? 0 : local.egress_rules_with_prefix_lists[count.index].to_port
#   ip_protocol = local.egress_rules_with_prefix_lists[count.index].protocol

#   cidr_ipv4                    = lookup([for rule in local.ingress_rules_without_prefix_lists : rule if rule.protocol != "-1"][count.index], "cidr_blocks", null)
#   cidr_ipv4                    = lookup(local.egress_rules_with_prefix_lists[count.index], "cidr_blocks", null) != null ? [local.egress_rules_with_prefix_lists[count.index].cidr_blocks] : null
#   referenced_security_group_id = lookup(local.egress_rules_with_prefix_lists[count.index], "destination_security_group_id", null)
#   prefix_list_id               = local.egress_rules_with_prefix_lists[count.index].prefix_list_ids
# }

# Continue using aws_vpc_security_group_ingress_rule for rules without prefix lists

# # Continue using aws_vpc_security_group_ingress_rule for rules without prefix lists
# resource "aws_vpc_security_group_ingress_rule" "ingress_with_ports" {
#   count = length([for rule in local.ingress_rules_without_prefix_lists : rule if rule.protocol != "-1"])

#   description       = lookup([for rule in local.ingress_rules_without_prefix_lists : rule if rule.protocol != "-1"][count.index], "description", null)
#   security_group_id = aws_security_group.this.id

#   cidr_ipv4                    = lookup([for rule in local.ingress_rules_without_prefix_lists : rule if rule.protocol != "-1"][count.index], "cidr_blocks", null)
#   from_port                    = [for rule in local.ingress_rules_without_prefix_lists : rule if rule.protocol != "-1"][count.index].from_port
#   to_port                      = [for rule in local.ingress_rules_without_prefix_lists : rule if rule.protocol != "-1"][count.index].to_port
#   ip_protocol                  = [for rule in local.ingress_rules_without_prefix_lists : rule if rule.protocol != "-1"][count.index].protocol
#   referenced_security_group_id = lookup([for rule in local.ingress_rules_without_prefix_lists : rule if rule.protocol != "-1"][count.index], "source_security_group_id", null)
#   # prefix_list_id               = lookup([for rule in local.ingress_rules_without_prefix_lists : rule if rule.protocol != "-1"][count.index], "prefix_list_ids", null)
# }

# Create ingress rules without from_port and to_port
# resource "aws_vpc_security_group_ingress_rule" "ingress_without_ports" {
#   count = length(local.ingress_rules_without_ports)

#   description       = lookup(local.ingress_rules_without_ports[count.index], "description", null)
#   security_group_id = aws_security_group.this.id

#   cidr_ipv4                    = lookup(local.ingress_rules_without_ports[count.index], "cidr_blocks", null)
#   ip_protocol                  = local.ingress_rules_without_ports[count.index].protocol
#   referenced_security_group_id = lookup(local.ingress_rules_without_ports[count.index], "source_security_group_id", null)
#   # prefix_list_id               = lookup(local.ingress_rules_without_ports[count.index], "prefix_list_ids", null)
# }

# # Create egress rules with from_port and to_port
# resource "aws_vpc_security_group_egress_rule" "egress_with_ports" {
#   count = length([for rule in local.egress_rules_without_prefix_lists : rule if rule.protocol != "-1"])

#   description       = lookup([for rule in local.egress_rules_without_prefix_lists : rule if rule.protocol != "-1"][count.index], "description", null)
#   security_group_id = aws_security_group.this.id

#   cidr_ipv4                    = lookup([for rule in local.egress_rules_without_prefix_lists : rule if rule.protocol != "-1"][count.index], "cidr_blocks", null)
#   from_port                    = [for rule in local.egress_rules_without_prefix_lists : rule if rule.protocol != "-1"][count.index].from_port
#   to_port                      = [for rule in local.egress_rules_without_prefix_lists : rule if rule.protocol != "-1"][count.index].to_port
#   ip_protocol                  = [for rule in local.egress_rules_without_prefix_lists : rule if rule.protocol != "-1"][count.index].protocol
#   referenced_security_group_id = lookup([for rule in local.egress_rules_without_prefix_lists : rule if rule.protocol != "-1"][count.index], "destination_security_group_id", null)
#   # prefix_list_id               = lookup([for rule in local.egress_rules_without_prefix_lists : rule if rule.protocol != "-1"][count.index], "prefix_list_ids", null)
# }

# # Create egress rules without from_port and to_port
# resource "aws_vpc_security_group_egress_rule" "egress_without_ports" {
#   count = length(local.egress_rules_without_ports)

#   description       = lookup(local.egress_rules_without_ports[count.index], "description", null)
#   security_group_id = aws_security_group.this.id

#   cidr_ipv4                    = lookup(local.egress_rules_without_ports[count.index], "cidr_blocks", null)
#   ip_protocol                  = local.egress_rules_without_ports[count.index].protocol
#   referenced_security_group_id = lookup(local.egress_rules_without_ports[count.index], "destination_security_group_id", null)
#   # prefix_list_id               = lookup(local.egress_rules_without_ports[count.index], "prefix_list_ids", null)
# }