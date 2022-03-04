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

/* -------------------------------------------------------------------------- */
/*                               SECURITY_GROUP_CLIENT                        */
/* -------------------------------------------------------------------------- */
resource "aws_security_group" "client" {
  name        = "${local.identifier}-client-sg"
  description = "Security group for the ${local.identifier} postgresql client"
  vpc_id      = var.vpc_id

  tags = merge(local.tags, { "Name" : "${local.identifier}-client-sg" })
}

/* -------------------------------------------------------------------------- */
/*                          SECURITY_GROUP_RULE_CLUSTER                       */
/* -------------------------------------------------------------------------- */

# Security group rule for incoming to cluster connections (allow only from client)
resource "aws_security_group_rule" "from_client" {
  type              = "ingress"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  security_group_id = local.rds_security_group_id
  description       = "Ingress rule for allow traffic from rds client security group"

  source_security_group_id = aws_security_group.client.id
}

resource "aws_security_group_rule" "to_internet" {
  type              = "egress"
  from_port         = -1
  to_port           = -1
  protocol          = "all"
  security_group_id = local.rds_security_group_id
  description       = "Egress rule for allow traffic to internet"

  cidr_blocks = ["0.0.0.0/0"]
}

/* -------------------------------------------------------------------------- */
/*                          SECURITY_GROUP_RULE_CLIENT                        */
/* -------------------------------------------------------------------------- */

# Security group rule for outgoing to cluster connections
resource "aws_security_group_rule" "to_cluster" {
  type              = "egress"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  security_group_id = aws_security_group.client.id
  description       = "Egress rule for allow traffic to rds cluster security group"

  source_security_group_id = local.rds_security_group_id
}

# Additional Security group rule for incoming and outgoing client
resource "aws_security_group_rule" "additional_client_ingress" {
  count = var.is_create_db_instance && var.is_create_security_group ? length(var.additional_client_security_group_ingress_rules) : null

  type                     = "ingress"
  from_port                = var.additional_client_security_group_ingress_rules[count.index].from_port
  to_port                  = var.additional_client_security_group_ingress_rules[count.index].to_port
  protocol                 = var.additional_client_security_group_ingress_rules[count.index].protocol
  cidr_blocks              = length(var.additional_client_security_group_ingress_rules[count.index].source_security_group_id) > 0 ? null : var.additional_client_security_group_ingress_rules[count.index].cidr_blocks
  source_security_group_id = length(var.additional_client_security_group_ingress_rules[count.index].cidr_blocks) > 0 ? null : var.additional_client_security_group_ingress_rules[count.index].source_security_group_id
  security_group_id        = aws_security_group.client.id
  description              = var.additional_client_security_group_ingress_rules[count.index].description
}

resource "aws_security_group_rule" "additional_client_egress" {
  count = var.is_create_db_instance && var.is_create_security_group ? length(var.additional_client_security_group_egress_rules) : null

  type                     = "egress"
  from_port                = var.additional_client_security_group_egress_rules[count.index].from_port
  to_port                  = var.additional_client_security_group_egress_rules[count.index].to_port
  protocol                 = var.additional_client_security_group_egress_rules[count.index].protocol
  cidr_blocks              = length(var.additional_client_security_group_egress_rules[count.index].source_security_group_id) > 0 ? null : var.additional_client_security_group_egress_rules[count.index].cidr_blocks
  source_security_group_id = length(var.additional_client_security_group_egress_rules[count.index].cidr_blocks) > 0 ? null : var.additional_client_security_group_egress_rules[count.index].source_security_group_id
  security_group_id        = aws_security_group.client.id
  description              = var.additional_client_security_group_egress_rules[count.index].description
}
