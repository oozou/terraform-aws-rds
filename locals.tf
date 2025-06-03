locals {
  parameter_group_name_id = var.is_create_parameter_group ? join("", aws_db_parameter_group.this.*.id) : var.db_parameter_group_name_id
  db_subnet_group_name    = var.is_create_db_subnet_group ? join("", aws_db_subnet_group.this.*.name) : var.db_subnet_group_name
  db_option_group_name    = var.is_create_option_group ? join("", aws_db_option_group.this.*.name) : var.db_option_group_name
  monitoring_role_arn     = var.is_enable_monitoring ? join("", aws_iam_role.enhanced_monitoring.*.arn) : var.monitoring_role_arn

  now = timestamp()

  identifier          = format("%s-%s-%s-db", var.prefix, var.environment, var.name)
  th_timezone         = timeadd(local.now, "7h")
  timestamp           = formatdate("YYYY-MM-DD-hh-mm", local.th_timezone)
  final_snapshot_name = var.skip_final_snapshot ? null : local.identifier

  rds_security_group_id = join("", aws_security_group.cluster.*.id)

  # KMS
  /*| a | b | (a: enable default kms, b: use custom kms)
    |---|---|
    | 0 | 0 | no create
    | 0 | 1 | use custom kms
    | 1 | 0 | use default kms
    | 1 | 1 | use custom kms */
  cloudwatch_log_group_kms_key_arn = var.cloudwatch_log_kms_key_arn != null ? var.cloudwatch_log_kms_key_arn : var.is_create_default_kms ? module.cloudwatch_log_group_kms[0].key_arn : null

  rds_db_creds = {
    host     = aws_db_instance.this[0].address
    port     = var.port
    username = var.username
    password = var.password
    engine   = var.engine
  }

  tags = merge(
    {
      Terraform   = true
      Environment = var.environment
    },
    var.custom_tags
  )

  /* -------------------------------------------------------------------------- */
  /*                                    Alarms                                  */
  /* -------------------------------------------------------------------------- */
  comparison_operators = {
    ">=" = "GreaterThanOrEqualToThreshold",
    ">"  = "GreaterThanThreshold",
    "<"  = "LessThanThreshold",
    "<=" = "LessThanOrEqualToThreshold",
  }


}
