/* -------------------------------------------------------------------------- */
/*                               SECURITY_GROUP_CLUSTER                       */
/* -------------------------------------------------------------------------- */
resource "aws_security_group" "cluster" {
  count = var.is_create_db_instance && var.is_create_security_group ? 1 : 0

  name        = "${local.identifier}-sg"
  description = "Security group for the ${local.identifier} postgresql"
  vpc_id      = var.vpc_id

  tags = merge(local.tags, { "Name" : "${local.identifier}-sg" })
}

resource "aws_security_group_rule" "ingress" {
  count = var.is_create_db_instance && var.is_create_security_group ? length(var.security_group_ingress_rules) : null

  type                     = "ingress"
  from_port                = var.security_group_ingress_rules[count.index].from_port
  to_port                  = var.security_group_ingress_rules[count.index].to_port
  protocol                 = var.security_group_ingress_rules[count.index].protocol
  cidr_blocks              = var.security_group_ingress_rules[count.index].is_cidr ? var.security_group_ingress_rules[count.index].cidr_blocks : null
  source_security_group_id = var.security_group_ingress_rules[count.index].is_sg ? var.security_group_ingress_rules[count.index].source_security_group_id : null
  security_group_id        = local.rds_security_group_id
  description              = var.security_group_ingress_rules[count.index].description

}

resource "aws_security_group_rule" "from_client" {
  type              = "ingress"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  security_group_id = local.rds_security_group_id
  description       = "Ingress rule for the rds instance security group"

  source_security_group_id = aws_security_group.client.id
}

resource "aws_security_group_rule" "egress" {
  count = var.is_create_db_instance && var.is_create_security_group ? length(var.security_group_egress_rules) : null

  type                     = "egress"
  from_port                = var.security_group_egress_rules[count.index].from_port
  to_port                  = var.security_group_egress_rules[count.index].to_port
  protocol                 = var.security_group_egress_rules[count.index].protocol
  cidr_blocks              = var.security_group_egress_rules[count.index].is_cidr ? var.security_group_egress_rules[count.index].cidr_blocks : null
  source_security_group_id = var.security_group_egress_rules[count.index].is_sg ? var.security_group_egress_rules[count.index].source_security_group_id : null
  security_group_id        = local.rds_security_group_id
  description              = var.security_group_egress_rules[count.index].description
}

/* -------------------------------------------------------------------------- */
/*                               SECURITY_GROUP_CLIENT                        */
/* -------------------------------------------------------------------------- */
resource "aws_security_group" "client" {
  name        = "${local.identifier}-client-sg"
  description = "Security group for the ${local.identifier} postgresql client"
  vpc_id      = var.vpc_id

  tags = merge(local.tags, { "Name" : "${local.identifier}-client-sg" })
}

# Security group rule for outgoing redis connections
resource "aws_security_group_rule" "to_cluster" {
  type              = "egress"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  security_group_id = aws_security_group.client.id
  description       = "Egress rule for the client security group"

  source_security_group_id = local.rds_security_group_id
}
