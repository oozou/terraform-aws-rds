/* -------------------------------------------------------------------------- */
/*                               AWS_DB_INSTANCE                              */
/* -------------------------------------------------------------------------- */
#https://registry.terraform.io/providers/hashicorp/aws/4.0.0/docs/resources/db_instance
resource "aws_db_instance" "this" {
  count = var.is_create_db_instance ? 1 : 0

  identifier = local.identifier

  # Database (server) defines
  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class
  license_model  = var.license_model

  # Database (storage) defines
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type
  iops              = var.iops
  storage_encrypted = var.storage_encrypted
  kms_key_id        = var.storage_encrypted ? join("", module.rds_kms.*.key_arn) : var.kms_key_id

  # Database (Schema) defines
  username                            = var.username
  password                            = var.password
  port                                = var.port
  iam_database_authentication_enabled = var.iam_database_authentication_enabled

  # Database (create from snapshot) defines
  snapshot_identifier = var.snapshot_identifier

  # Database (networking) defines
  vpc_security_group_ids = [try(aws_security_group.this[0].id, "")]
  availability_zone      = var.availability_zone
  multi_az               = var.multi_az
  publicly_accessible    = var.publicly_accessible

  # Resources available in respective tf files
  db_subnet_group_name = local.db_subnet_group_name
  parameter_group_name = local.parameter_group_name_id

  # need to add option group support
  # option_group_name = local.db_option_group_name

  monitoring_interval = var.monitoring_interval

  # need to add monitoring arn
  # monitoring_role_arn = "${coalesce(var.monitoring_role_arn, join("", aws_iam_role.enhanced_monitoring.*.arn))}"

  # Database (backup) defines
  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window

  # Database (additional config) defines
  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  apply_immediately           = var.apply_immediately
  maintenance_window          = var.maintenance_window
  skip_final_snapshot         = var.skip_final_snapshot
  copy_tags_to_snapshot       = var.copy_tags_to_snapshot
  final_snapshot_identifier   = var.final_snapshot_identifier

  # Database (logging) defines
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  timeouts {
    create = lookup(var.timeouts, "create", null)
    delete = lookup(var.timeouts, "delete", null)
    update = lookup(var.timeouts, "update", null)
  }

  deletion_protection = var.deletion_protection

  tags = merge(local.tags, { "Name" : format("%s", local.identifier) })

  # unused parameters
  # replicate_source_db = "${var.replicate_source_db}"
}
