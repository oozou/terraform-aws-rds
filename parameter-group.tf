/* -------------------------------------------------------------------------- */
/*                           AWS_DB_PARAMETER_GROUP                           */
/* -------------------------------------------------------------------------- */
resource "aws_db_parameter_group" "this" {
  count = var.is_create_db_instance && var.is_create_parameter_group ? 1 : 0

  name        = "${local.identifier}-param"
  description = format("Database parameter group for %s", local.identifier)
  family      = var.family

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = lookup(parameter.value, "apply_method", null)
    }
  }

  tags = merge(local.tags, { Name = "${local.identifier}-param" })
}
