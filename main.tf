/* -------------------------------------------------------------------------- */
/*                               AWS_DB_INSTANCE                              */
/* -------------------------------------------------------------------------- */
#https://registry.terraform.io/providers/hashicorp/aws/4.0.0/docs/resources/db_instance
resource "aws_db_instance" "this" {
  count = var.is_create_db_instance ? 1 : 0

  identifier = local.identifier

  # Database (server) defines
  engine             = var.engine
  engine_version     = var.engine_version
  instance_class     = var.instance_class
  license_model      = var.license_model      #oracle, mssql
  ca_cert_identifier = var.ca_cert_identifier #oracle, mssql
  timezone           = var.timezone           #mssql

  # Database (storage) defines
  allocated_storage     = var.allocated_storage
  storage_type          = var.storage_type
  iops                  = var.iops
  storage_throughput    = var.storage_type == "gp3" ? var.storage_throughput : null
  max_allocated_storage = var.max_allocated_storage
  storage_encrypted     = var.storage_encrypted
  kms_key_id            = var.storage_encrypted ? join("", module.rds_kms.*.key_arn) : var.kms_key_id

  # Database (Schema) defines
  username                            = var.username
  password                            = var.password
  port                                = var.port
  iam_database_authentication_enabled = var.iam_database_authentication_enabled

  # Database (create from snapshot) defines
  snapshot_identifier = var.snapshot_identifier

  # Database (networking) defines
  vpc_security_group_ids = [try(aws_security_group.cluster[0].id, "")]
  availability_zone      = var.availability_zone
  multi_az               = var.multi_az
  publicly_accessible    = var.publicly_accessible

  # Resources available in respective tf files
  db_subnet_group_name = local.db_subnet_group_name
  parameter_group_name = local.parameter_group_name_id

  # option group
  option_group_name = local.db_option_group_name

  # monitoring
  monitoring_interval                   = var.monitoring_interval
  monitoring_role_arn                   = local.monitoring_role_arn
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_kms_key_id       = var.performance_insights_enabled && var.performance_insights_use_cmk ? join("", module.rds_kms.*.key_arn) : var.performance_insights_kms_key_id
  performance_insights_retention_period = var.performance_insights_enabled ? var.performance_insights_retention_period : null

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
  final_snapshot_identifier   = local.final_snapshot_name

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
  depends_on = [
    aws_cloudwatch_log_group.this
  ]
}



# ################## Credentials ######################
# Store Postgres Master Credentials in the secret manager
# at this time, Terraform doesn't support RDS credential type, but we are storing rds connection details in the same format as AWS does for RDS type
# https://docs.aws.amazon.com/secretsmanager/latest/userguide/terms-concepts.html
# https://github.com/terraform-providers/terraform-provider-aws/issues/4953


# Append random string to SM Secret names because once we tear down the infra, the secret does not actually
# get deleted right away, which means that if we then try to recreate the infra, it'll fail as the
# secret name already exists.
resource "random_string" "postgres_creds_random_suffix" {
  length  = 6
  special = false
}

resource "aws_secretsmanager_secret" "postgres_creds" {
  count = var.is_create_db_instance && var.is_create_secret? 1 : 0
  name        = "${lower(local.identifier)}/postgres-master-creds--${random_string.postgres_creds_random_suffix.result}"
  description = "Postgres RDS Master Credentials"
  kms_key_id  = module.postgres_creds_kms_key[0].key_id

  tags = merge({
    Name = "${local.identifier}/postgres-master-creds"

  }, var.custom_tags)
}

resource "aws_secretsmanager_secret_version" "postgres_creds" {
  count = var.is_create_db_instance && var.is_create_secret? 1 : 0
  secret_id     = aws_secretsmanager_secret.postgres_creds[0].id
  secret_string = jsonencode(local.postgres_db_creds)
}
