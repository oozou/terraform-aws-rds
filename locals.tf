locals {
  parameter_group_name_id = var.is_create_parameter_group_name ? join("", aws_db_parameter_group.this.*.id) : var.db_parameter_group_name_id
  db_subnet_group_name    = var.is_create_db_subnet_group_name ? join("", aws_db_subnet_group.this.*.name) : var.db_subnet_group_name

  rds_security_group_id = join("", aws_security_group.this.*.id)

  identifier = format("%s-%s-%s-%s", var.prefix, var.environment, var.name, "db")

  environment = var.environment

  tags = merge(
    {
      Terraform   = true
      Environment = local.environment
    },
    var.custom_tags
  )
}
