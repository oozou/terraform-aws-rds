locals {
  parameter_group_name_id = var.is_create_parameter_group ? join("", aws_db_parameter_group.this.*.id) : var.db_parameter_group_name_id
  db_subnet_group_name    = var.is_create_db_subnet_group ? join("", aws_db_subnet_group.this.*.name) : var.db_subnet_group_name

  now = timestamp()

  th_timezone         = timeadd(local.now, "7h")
  timestamp           = formatdate("YYYY-MM-DD-hh-mm", local.th_timezone)
  final_snapshot_name = var.skip_final_snapshot ? null : format("%s-%s", local.identifier, local.timestamp)

  rds_security_group_id = join("", aws_security_group.cluster.*.id)

  identifier = format("%s-%s-%s-db", var.prefix, var.environment, var.name)

  tags = merge(
    {
      Terraform   = true
      Environment = var.environment
    },
    var.custom_tags
  )
}
