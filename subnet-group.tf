/* -------------------------------------------------------------------------- */
/*                             AWS_DB_SUBNET_GROUP                            */
/* -------------------------------------------------------------------------- */
resource "aws_db_subnet_group" "this" {
  count = var.is_create_db_instance && var.is_create_db_subnet_group ? 1 : 0

  name        = "${local.identifier}-sngroup"
  description = format("Database subnet group for %s", local.identifier)
  subnet_ids  = var.subnet_ids

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.tags, { Name = "${local.identifier}-sngroup" })
}
