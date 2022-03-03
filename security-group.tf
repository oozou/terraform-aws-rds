/* -------------------------------------------------------------------------- */
/*                               SECURITY_GROUP                               */
/* -------------------------------------------------------------------------- */
resource "aws_security_group" "this" {
  count = var.is_create_db_instance && var.is_create_security_group ? 1 : 0

  name        = "${local.identifier}-sg"
  description = "Security group for the ${local.identifier} postgresql"
  vpc_id      = var.vpc_id

  tags = merge(local.tags, { "Name" : "${local.identifier}-sg" })
}

resource "aws_security_group_rule" "ingress" {
  for_each = var.is_create_db_instance && var.is_create_security_group ? var.security_group_ingress_rules : null

  type                     = "ingress"
  from_port                = lookup(each.value, "from_port", var.port)
  to_port                  = lookup(each.value, "to_port", var.port)
  protocol                 = lookup(each.value, "protocol", "tcp")
  cidr_blocks              = lookup(each.value, "cidr_blocks", null)
  source_security_group_id = lookup(each.value, "source_security_group_id", null)
  security_group_id        = local.rds_security_group_id
  description              = lookup(each.value, "description", null)
}

resource "aws_security_group_rule" "egress" {
  for_each = var.is_create_db_instance && var.is_create_security_group ? var.security_group_egress_rules : null

  # required
  type              = "egress"
  from_port         = lookup(each.value, "from_port", var.port)
  to_port           = lookup(each.value, "to_port", var.port)
  protocol          = lookup(each.value, "protocol", "tcp")
  security_group_id = local.rds_security_group_id

  # optional
  cidr_blocks              = lookup(each.value, "cidr_blocks", null)
  description              = lookup(each.value, "description", null)
  ipv6_cidr_blocks         = lookup(each.value, "ipv6_cidr_blocks", null)
  prefix_list_ids          = lookup(each.value, "prefix_list_ids", null)
  source_security_group_id = lookup(each.value, "source_security_group_id", null)
}
