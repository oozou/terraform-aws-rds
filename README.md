# terraform-aws-rds-postgresql

## Usage

**RDS PostgreSQL**

```terraform
module "rds_postgres" {
  source = "<your_select_source>"

  prefix      = "<customer_name>"
  name        = "<paas_name>"
  environment = "dev"

  #db instance (server)
  engine         = "postgres"
  engine_version = "14.1"
  instance_class = "db.t3.small"

  #db instance (storage)
  allocated_storage     = 20
  storage_encrypted     = true
  max_allocated_storage = 50

  #db instance (schema)
  username = "postgres"
  password = "qwertyuiop[]"
  port     = 5432

  #db instance (monitoring)
  is_enable_monitoring                  = true
  monitoring_interval                   = 60
  performance_insights_enabled          = true
  performance_insights_use_cmk          = true
  performance_insights_retention_period = 7

  #db instance (backup)
  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 7

  #db instance (additional)
  skip_final_snapshot = false
  deletion_protection = false

  #db instance (logging)
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  #security group
  vpc_id = "vpc-0736560f271b12fa3"
  additional_client_security_group_ingress_rules = [{
    cidr_blocks              = ["0.0.0.0/0"]
    description              = "allow from any"
    from_port                = 5432
    is_cidr                  = true
    is_sg                    = false
    protocol                 = "tcp"
    source_security_group_id = ""
    to_port                  = 5432
    },
    {
      cidr_blocks              = ["0.0.0.0/0"]
      description              = "allow from any"
      from_port                = 80
      is_cidr                  = false
      is_sg                    = true
      protocol                 = "tcp"
      source_security_group_id = "<sg-id>"
      to_port                  = 80
  }]

  additional_client_security_group_egress_rules = [{
    cidr_blocks              = ["0.0.0.0/0"]
    description              = "allow to any"
    from_port                = -1
    is_cidr                  = true
    is_sg                    = false
    protocol                 = "all"
    source_security_group_id = ""
    to_port                  = -1
  }]

  #parameter group
  family = "postgres14"
  parameters = [{
    "name"         = "timezone"
    "value"        = "Asia/Bangkok"
    "apply_method" = "immediate"
  }]

  #subnet group
  subnet_ids = ["subnet-09ef78e7234432ce6", "subnet-0b8e065bee1ab6d50", "subnet-0e0c33e9873deaff8"]

  custom_tags = {
    "Workspace" : "<workspace_name>"
  }
}
```

**Microsoft SQL**

```terraform
module "rds_mssql" {
  source = "<your_select_source>"

  prefix      = "<customer_name>"
  name        = "<paas_name>"
  environment = "dev"

  #db instance (server)
  engine         = "sqlserver-web"
  engine_version = "15.00.4153.1.v1"
  instance_class = "db.t3.small"
  license_model  = "license-included"
  timezone       = "GMT Standard Time"

  #db instance (storage)
  allocated_storage     = 20
  storage_encrypted     = true
  max_allocated_storage = 50

  #db instance (schema)
  username = "admin"
  password = "qwertyuiop[]"
  port     = 1433

  #db instance (monitoring)
  is_enable_monitoring                  = true
  monitoring_interval                   = 60
  performance_insights_enabled          = true
  performance_insights_use_cmk          = true
  performance_insights_retention_period = 7

  #db instance (backup)
  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 7

  #db instance (additional)
  skip_final_snapshot = false
  deletion_protection = false

  #db instance (logging)
  enabled_cloudwatch_logs_exports = ["agent", "error"]

  #security group
  vpc_id = "vpc-0736560f271b12fa3"
  additional_client_security_group_ingress_rules = [{
    cidr_blocks              = ["0.0.0.0/0"]
    description              = "allow from any"
    from_port                = 1433
    is_cidr                  = true
    is_sg                    = false
    protocol                 = "tcp"
    source_security_group_id = ""
    to_port                  = 1433
    },
    {
      cidr_blocks              = ["0.0.0.0/0"]
      description              = "allow from any"
      from_port                = 80
      is_cidr                  = false
      is_sg                    = true
      protocol                 = "tcp"
      source_security_group_id = "<sg-id>"
      to_port                  = 80
  }]

  additional_client_security_group_egress_rules = [{
    cidr_blocks              = ["0.0.0.0/0"]
    description              = "allow to any"
    from_port                = -1
    is_cidr                  = true
    is_sg                    = false
    protocol                 = "all"
    source_security_group_id = ""
    to_port                  = -1
  }]

  #parameter group
  family = "sqlserver-web-15.0"
  parameters = [{
    name         = "<parameter_name>"
    value        = "<value>"
    apply_method = immediate
  }]

  #subnet group
  subnet_ids = ["subnet-09ef78e7234432ce6", "subnet-0b8e065bee1ab6d50", "subnet-0e0c33e9873deaff8"]

  #option group
  is_create_option_group         = true
  db_option_engine_name          = "sqlserver-web"
  db_option_major_engine_version = "15.00"
  db_options = [{
    option_name                    = "SQLSERVER_BACKUP_RESTORE"
    db_security_group_memberships  = []
    port                           = null
    version                        = ""
    vpc_security_group_memberships = []
    option_settings = [{
      name  = "IAM_ROLE_ARN"
      value = "<role-backup-s3-arn>"
    }]
  }]

  custom_tags = {
    "Workspace" : "<workspace_name>"
  }
}
```

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                                     | Version  |
| ------------------------------------------------------------------------ | -------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | >= 4.0.0 |

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | 4.3.0   |

## Modules

| Name                                                     | Source                                         | Version |
| -------------------------------------------------------- | ---------------------------------------------- | ------- |
| <a name="module_rds_kms"></a> [rds_kms](#module_rds_kms) | git@github.com:oozou/terraform-aws-kms-key.git | v0.0.1  |

## Resources

| Name                                                                                                                                                 | Type     |
| ---------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [aws_db_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance)                                      | resource |
| [aws_db_option_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_option_group)                              | resource |
| [aws_db_parameter_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group)                        | resource |
| [aws_db_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group)                              | resource |
| [aws_iam_role.enhanced_monitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                             | resource |
| [aws_security_group.client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                              | resource |
| [aws_security_group.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                             | resource |
| [aws_security_group_rule.additional_client_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule)  | resource |
| [aws_security_group_rule.additional_client_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.from_client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule)               | resource |
| [aws_security_group_rule.to_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule)                | resource |

## Inputs

| Name                                                                                                                                                                        | Description                                                                                                                                                                                                                                                                                                       | Type                                                                                                                                                                                                                                                                                     | Default                                                                          | Required |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------- | :------: |
| <a name="input_additional_client_security_group_egress_rules"></a> [additional_client_security_group_egress_rules](#input_additional_client_security_group_egress_rules)    | Additional egress rule for client security group.                                                                                                                                                                                                                                                                 | <pre>list(object({<br> from_port = number<br> to_port = number<br> protocol = string<br> cidr_blocks = list(string)<br> source_security_group_id = string<br> description = string<br> }))</pre>                                                                                         | `[]`                                                                             |    no    |
| <a name="input_additional_client_security_group_ingress_rules"></a> [additional_client_security_group_ingress_rules](#input_additional_client_security_group_ingress_rules) | Additional ingress rule for client security group.                                                                                                                                                                                                                                                                | <pre>list(object({<br> from_port = number<br> to_port = number<br> protocol = string<br> cidr_blocks = list(string)<br> source_security_group_id = string<br> description = string<br> }))</pre>                                                                                         | `[]`                                                                             |    no    |
| <a name="input_allocated_storage"></a> [allocated_storage](#input_allocated_storage)                                                                                        | The allocated storage in gigabytes                                                                                                                                                                                                                                                                                | `number`                                                                                                                                                                                                                                                                                 | n/a                                                                              |   yes    |
| <a name="input_allow_major_version_upgrade"></a> [allow_major_version_upgrade](#input_allow_major_version_upgrade)                                                          | Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible                                                                                                                                              | `bool`                                                                                                                                                                                                                                                                                   | `false`                                                                          |    no    |
| <a name="input_apply_immediately"></a> [apply_immediately](#input_apply_immediately)                                                                                        | Specifies whether any database modifications are applied immediately, or during the next maintenance window                                                                                                                                                                                                       | `bool`                                                                                                                                                                                                                                                                                   | `false`                                                                          |    no    |
| <a name="input_auto_minor_version_upgrade"></a> [auto_minor_version_upgrade](#input_auto_minor_version_upgrade)                                                             | Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window                                                                                                                                                                                               | `bool`                                                                                                                                                                                                                                                                                   | `true`                                                                           |    no    |
| <a name="input_availability_zone"></a> [availability_zone](#input_availability_zone)                                                                                        | The AZ for the RDS instance.                                                                                                                                                                                                                                                                                      | `string`                                                                                                                                                                                                                                                                                 | `""`                                                                             |    no    |
| <a name="input_backup_retention_period"></a> [backup_retention_period](#input_backup_retention_period)                                                                      | The days to retain backups for. Mostly, for non-production is 7 days and production is 30 days. Default to 7 days                                                                                                                                                                                                 | `number`                                                                                                                                                                                                                                                                                 | `30`                                                                             |    no    |
| <a name="input_backup_window"></a> [backup_window](#input_backup_window)                                                                                                    | The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window                                                                                                                                                    | `string`                                                                                                                                                                                                                                                                                 | `null`                                                                           |    no    |
| <a name="input_ca_cert_identifier"></a> [ca_cert_identifier](#input_ca_cert_identifier)                                                                                     | The identifier of the CA certificate for the DB instance                                                                                                                                                                                                                                                          | `string`                                                                                                                                                                                                                                                                                 | `null`                                                                           |    no    |
| <a name="input_copy_tags_to_snapshot"></a> [copy_tags_to_snapshot](#input_copy_tags_to_snapshot)                                                                            | On delete, copy all Instance tags to the final snapshot (if final_snapshot_identifier is specified)                                                                                                                                                                                                               | `bool`                                                                                                                                                                                                                                                                                   | `true`                                                                           |    no    |
| <a name="input_custom_tags"></a> [custom_tags](#input_custom_tags)                                                                                                          | Tags to add more; default tags contian {terraform=true, environment=var.environment}                                                                                                                                                                                                                              | `map(string)`                                                                                                                                                                                                                                                                            | `{}`                                                                             |    no    |
| <a name="input_db_option_engine_name"></a> [db_option_engine_name](#input_db_option_engine_name)                                                                            | Specifies the name of the engine that this option group should be associated with. If is_create_option_group is set to true this parameter is required. Ref:https://docs.aws.amazon.com/cli/latest/reference/rds/create-option-group.html                                                                         | `string`                                                                                                                                                                                                                                                                                 | `""`                                                                             |    no    |
| <a name="input_db_option_group_name"></a> [db_option_group_name](#input_db_option_group_name)                                                                               | if is_create_option_group is false, input existed option group name. If unspecified, the default option group will be used.                                                                                                                                                                                       | `string`                                                                                                                                                                                                                                                                                 | `""`                                                                             |    no    |
| <a name="input_db_option_major_engine_version"></a> [db_option_major_engine_version](#input_db_option_major_engine_version)                                                 | Database MAJOR engine version, depends on engine type                                                                                                                                                                                                                                                             | `string`                                                                                                                                                                                                                                                                                 | `""`                                                                             |    no    |
| <a name="input_db_options"></a> [db_options](#input_db_options)                                                                                                             | A list of DB options to apply with an option group. Depends on DB engine                                                                                                                                                                                                                                          | <pre>list(object({<br> db_security_group_memberships = list(string)<br> option_name = string<br> port = number<br> version = string<br> vpc_security_group_memberships = list(string)<br><br> option_settings = list(object({<br> name = string<br> value = string<br> }))<br> }))</pre> | `[]`                                                                             |    no    |
| <a name="input_db_parameter_group_name_id"></a> [db_parameter_group_name_id](#input_db_parameter_group_name_id)                                                             | if is_create_parameter_group is false, input existed parameter group name id. If unspecified, the default parameter group will be used.                                                                                                                                                                           | `string`                                                                                                                                                                                                                                                                                 | `null`                                                                           |    no    |
| <a name="input_db_subnet_group_name"></a> [db_subnet_group_name](#input_db_subnet_group_name)                                                                               | if is_create_db_subnet_group is false, input existed subnet group name. If unspecified, the default vpc subnet group will be used.                                                                                                                                                                                | `string`                                                                                                                                                                                                                                                                                 | `""`                                                                             |    no    |
| <a name="input_deletion_protection"></a> [deletion_protection](#input_deletion_protection)                                                                                  | The database can't be deleted when this value is set to true.                                                                                                                                                                                                                                                     | `bool`                                                                                                                                                                                                                                                                                   | `false`                                                                          |    no    |
| <a name="input_enabled_cloudwatch_logs_exports"></a> [enabled_cloudwatch_logs_exports](#input_enabled_cloudwatch_logs_exports)                                              | List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine): MySQL and MariaDB: audit, error, general, slowquery. PostgreSQL: postgresql, upgrade. MSSQL: agent , error. Oracle: alert, audit, listener, trace.                        | `list(string)`                                                                                                                                                                                                                                                                           | `[]`                                                                             |    no    |
| <a name="input_engine"></a> [engine](#input_engine)                                                                                                                         | The database engine to use                                                                                                                                                                                                                                                                                        | `string`                                                                                                                                                                                                                                                                                 | n/a                                                                              |   yes    |
| <a name="input_engine_version"></a> [engine_version](#input_engine_version)                                                                                                 | The engine version to use. If auto_minor_version_upgrade is enabled, you can provide a prefix of the version such as 5.7 (for 5.7.10). The actual engine version used is returned in the attribute engine_version_actual, defined below.                                                                          | `string`                                                                                                                                                                                                                                                                                 | n/a                                                                              |   yes    |
| <a name="input_environment"></a> [environment](#input_environment)                                                                                                          | Environment name used as environment resources name.                                                                                                                                                                                                                                                              | `string`                                                                                                                                                                                                                                                                                 | n/a                                                                              |   yes    |
| <a name="input_family"></a> [family](#input_family)                                                                                                                         | The database family to use                                                                                                                                                                                                                                                                                        | `string`                                                                                                                                                                                                                                                                                 | n/a                                                                              |   yes    |
| <a name="input_iam_database_authentication_enabled"></a> [iam_database_authentication_enabled](#input_iam_database_authentication_enabled)                                  | Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled                                                                                                                                                                                                | `string`                                                                                                                                                                                                                                                                                 | `false`                                                                          |    no    |
| <a name="input_instance_class"></a> [instance_class](#input_instance_class)                                                                                                 | The instance type of the RDS instance                                                                                                                                                                                                                                                                             | `string`                                                                                                                                                                                                                                                                                 | n/a                                                                              |   yes    |
| <a name="input_iops"></a> [iops](#input_iops)                                                                                                                               | The amount of provisioned IOPS. Setting this implies a storage_type of 'io1'                                                                                                                                                                                                                                      | `number`                                                                                                                                                                                                                                                                                 | `0`                                                                              |    no    |
| <a name="input_is_create_db_instance"></a> [is_create_db_instance](#input_is_create_db_instance)                                                                            | Whether to create db instance or not                                                                                                                                                                                                                                                                              | `bool`                                                                                                                                                                                                                                                                                   | `true`                                                                           |    no    |
| <a name="input_is_create_db_subnet_group"></a> [is_create_db_subnet_group](#input_is_create_db_subnet_group)                                                                | Whether to create db subnet group or not                                                                                                                                                                                                                                                                          | `bool`                                                                                                                                                                                                                                                                                   | `true`                                                                           |    no    |
| <a name="input_is_create_option_group"></a> [is_create_option_group](#input_is_create_option_group)                                                                         | Whether to create db option group or not (Require for some DB engine)                                                                                                                                                                                                                                             | `bool`                                                                                                                                                                                                                                                                                   | `false`                                                                          |    no    |
| <a name="input_is_create_parameter_group"></a> [is_create_parameter_group](#input_is_create_parameter_group)                                                                | Whether to create parameter group or not                                                                                                                                                                                                                                                                          | `bool`                                                                                                                                                                                                                                                                                   | `true`                                                                           |    no    |
| <a name="input_is_create_security_group"></a> [is_create_security_group](#input_is_create_security_group)                                                                   | Determines whether to create security group for RDS cluster                                                                                                                                                                                                                                                       | `bool`                                                                                                                                                                                                                                                                                   | `true`                                                                           |    no    |
| <a name="input_is_enable_monitoring"></a> [is_enable_monitoring](#input_is_enable_monitoring)                                                                               | Whether to enable enhanced monitoring.                                                                                                                                                                                                                                                                            | `bool`                                                                                                                                                                                                                                                                                   | `false`                                                                          |    no    |
| <a name="input_kms_key_id"></a> [kms_key_id](#input_kms_key_id)                                                                                                             | The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN. If storage_encrypted is set to true and kms_key_id is not specified the default KMS key created in your account will be used                                                                           | `string`                                                                                                                                                                                                                                                                                 | `null`                                                                           |    no    |
| <a name="input_license_model"></a> [license_model](#input_license_model)                                                                                                    | License model for this DB. Optional, but required for some DB Engines. Valid values: license-included \| bring-your-own-license \| general-public-license                                                                                                                                                         | `string`                                                                                                                                                                                                                                                                                 | `""`                                                                             |    no    |
| <a name="input_maintenance_window"></a> [maintenance_window](#input_maintenance_window)                                                                                     | The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'                                                                                                                                                                                                                | `string`                                                                                                                                                                                                                                                                                 | `null`                                                                           |    no    |
| <a name="input_max_allocated_storage"></a> [max_allocated_storage](#input_max_allocated_storage)                                                                            | When configured, the upper limit to which Amazon RDS can automatically scale the storage of the DB instance. Must be greater than or equal to allocated_storage or leave as default to disable Storage Autoscaling                                                                                                | `number`                                                                                                                                                                                                                                                                                 | `0`                                                                              |    no    |
| <a name="input_monitoring_interval"></a> [monitoring_interval](#input_monitoring_interval)                                                                                  | The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60.                                                                               | `number`                                                                                                                                                                                                                                                                                 | `0`                                                                              |    no    |
| <a name="input_monitoring_role_arn"></a> [monitoring_role_arn](#input_monitoring_role_arn)                                                                                  | The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs. Must be specified if monitoring_interval is non-zero. If unspecified, terraform will create new role.                                                                                                           | `string`                                                                                                                                                                                                                                                                                 | `""`                                                                             |    no    |
| <a name="input_multi_az"></a> [multi_az](#input_multi_az)                                                                                                                   | Specifies if the RDS instance is multi-AZ                                                                                                                                                                                                                                                                         | `bool`                                                                                                                                                                                                                                                                                   | `false`                                                                          |    no    |
| <a name="input_name"></a> [name](#input_name)                                                                                                                               | Name used as a resources name.                                                                                                                                                                                                                                                                                    | `string`                                                                                                                                                                                                                                                                                 | n/a                                                                              |   yes    |
| <a name="input_parameters"></a> [parameters](#input_parameters)                                                                                                             | A list of DB parameter maps to apply                                                                                                                                                                                                                                                                              | <pre>list(object({<br> apply_method = string<br> name = string<br> value = string<br> }))</pre>                                                                                                                                                                                          | `[]`                                                                             |    no    |
| <a name="input_password"></a> [password](#input_password)                                                                                                                   | (Required unless a snapshot_identifier or replicate_source_db is provided) Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file.                                                                                                                          | `string`                                                                                                                                                                                                                                                                                 | n/a                                                                              |   yes    |
| <a name="input_performance_insights_enabled"></a> [performance_insights_enabled](#input_performance_insights_enabled)                                                       | whether Performance Insights are enabled.                                                                                                                                                                                                                                                                         | `bool`                                                                                                                                                                                                                                                                                   | `false`                                                                          |    no    |
| <a name="input_performance_insights_kms_key_id"></a> [performance_insights_kms_key_id](#input_performance_insights_kms_key_id)                                              | The ARN for the KMS key to encrypt Performance Insights data. Once KMS key is set, it can never be changed. If performance_insights_enabled is set to true and performance_insights_use_cmk is set to false and performance_insights_kms_key_id is not specified the default KMS key in your account will be used | `string`                                                                                                                                                                                                                                                                                 | `null`                                                                           |    no    |
| <a name="input_performance_insights_retention_period"></a> [performance_insights_retention_period](#input_performance_insights_retention_period)                            | The amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years).                                                                                                                                                                                                               | `number`                                                                                                                                                                                                                                                                                 | `null`                                                                           |    no    |
| <a name="input_performance_insights_use_cmk"></a> [performance_insights_use_cmk](#input_performance_insights_use_cmk)                                                       | whether Performance Insights encryption using customer managed key(KMS).                                                                                                                                                                                                                                          | `bool`                                                                                                                                                                                                                                                                                   | `false`                                                                          |    no    |
| <a name="input_port"></a> [port](#input_port)                                                                                                                               | The port on which the DB accepts connections. Mostly, postgres=5432, mssql=1433, mariadb=3306                                                                                                                                                                                                                     | `number`                                                                                                                                                                                                                                                                                 | n/a                                                                              |   yes    |
| <a name="input_prefix"></a> [prefix](#input_prefix)                                                                                                                         | The prefix name of customer to be displayed in AWS console and resource.                                                                                                                                                                                                                                          | `string`                                                                                                                                                                                                                                                                                 | n/a                                                                              |   yes    |
| <a name="input_publicly_accessible"></a> [publicly_accessible](#input_publicly_accessible)                                                                                  | Bool to control if instance is publicly accessible                                                                                                                                                                                                                                                                | `bool`                                                                                                                                                                                                                                                                                   | `false`                                                                          |    no    |
| <a name="input_skip_final_snapshot"></a> [skip_final_snapshot](#input_skip_final_snapshot)                                                                                  | Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier                                            | `bool`                                                                                                                                                                                                                                                                                   | `false`                                                                          |    no    |
| <a name="input_snapshot_identifier"></a> [snapshot_identifier](#input_snapshot_identifier)                                                                                  | Specifies whether or not to create this database from a snapshot. This correlates to the snapshot ID you'd find in the RDS console, e.g: rds:production-2015-06-26-06-05.                                                                                                                                         | `string`                                                                                                                                                                                                                                                                                 | `null`                                                                           |    no    |
| <a name="input_storage_encrypted"></a> [storage_encrypted](#input_storage_encrypted)                                                                                        | Specifies whether the DB instance is encrypted                                                                                                                                                                                                                                                                    | `bool`                                                                                                                                                                                                                                                                                   | `false`                                                                          |    no    |
| <a name="input_storage_type"></a> [storage_type](#input_storage_type)                                                                                                       | One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'standard' if not. Note that this behaviour is different from the AWS web console, where the default is 'gp2'.                                                             | `string`                                                                                                                                                                                                                                                                                 | `"gp2"`                                                                          |    no    |
| <a name="input_subnet_ids"></a> [subnet_ids](#input_subnet_ids)                                                                                                             | A list of VPC subnet IDs                                                                                                                                                                                                                                                                                          | `list(string)`                                                                                                                                                                                                                                                                           | `[]`                                                                             |    no    |
| <a name="input_timeouts"></a> [timeouts](#input_timeouts)                                                                                                                   | Updated Terraform resource management timeouts. Applies to `aws_db_instance` in particular to permit resource management times                                                                                                                                                                                    | `map(string)`                                                                                                                                                                                                                                                                            | <pre>{<br> "create": "120m",<br> "delete": "40m",<br> "update": "80m"<br>}</pre> |    no    |
| <a name="input_timezone"></a> [timezone](#input_timezone)                                                                                                                   | Time zone of the DB instance. timezone is currently only supported by Microsoft SQL Server. The timezone can only be set on creation. See MSSQL User Guide for more information.                                                                                                                                  | `string`                                                                                                                                                                                                                                                                                 | `""`                                                                             |    no    |
| <a name="input_username"></a> [username](#input_username)                                                                                                                   | (Required unless a snapshot_identifier or replicate_source_db is provided) Username for the master DB user. Cannot be specified for a replica.                                                                                                                                                                    | `string`                                                                                                                                                                                                                                                                                 | n/a                                                                              |   yes    |
| <a name="input_vpc_id"></a> [vpc_id](#input_vpc_id)                                                                                                                         | ID of the VPC where to create security group                                                                                                                                                                                                                                                                      | `string`                                                                                                                                                                                                                                                                                 | n/a                                                                              |   yes    |

## Outputs

| Name                                                                                                                                | Description                                                                             |
| ----------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| <a name="output_db_client_security_group_id"></a> [db_client_security_group_id](#output_db_client_security_group_id)                | Security group id for the rds client.                                                   |
| <a name="output_db_instance_address"></a> [db_instance_address](#output_db_instance_address)                                        | The address of the RDS instance                                                         |
| <a name="output_db_instance_arn"></a> [db_instance_arn](#output_db_instance_arn)                                                    | The ARN of the RDS instance                                                             |
| <a name="output_db_instance_availability_zone"></a> [db_instance_availability_zone](#output_db_instance_availability_zone)          | The availability zone of the RDS instance                                               |
| <a name="output_db_instance_ca_cert_identifier"></a> [db_instance_ca_cert_identifier](#output_db_instance_ca_cert_identifier)       | Specifies the identifier of the CA certificate for the DB instance                      |
| <a name="output_db_instance_domain"></a> [db_instance_domain](#output_db_instance_domain)                                           | The ID of the Directory Service Active Directory domain the instance is joined to       |
| <a name="output_db_instance_domain_iam_role_name"></a> [db_instance_domain_iam_role_name](#output_db_instance_domain_iam_role_name) | The name of the IAM role to be used when making API calls to the Directory Service.     |
| <a name="output_db_instance_endpoint"></a> [db_instance_endpoint](#output_db_instance_endpoint)                                     | The connection endpoint                                                                 |
| <a name="output_db_instance_hosted_zone_id"></a> [db_instance_hosted_zone_id](#output_db_instance_hosted_zone_id)                   | The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record) |
| <a name="output_db_instance_id"></a> [db_instance_id](#output_db_instance_id)                                                       | The RDS instance ID                                                                     |
| <a name="output_db_instance_master_password"></a> [db_instance_master_password](#output_db_instance_master_password)                | The master password                                                                     |
| <a name="output_db_instance_name"></a> [db_instance_name](#output_db_instance_name)                                                 | The database name                                                                       |
| <a name="output_db_instance_port"></a> [db_instance_port](#output_db_instance_port)                                                 | The database port                                                                       |
| <a name="output_db_instance_resource_id"></a> [db_instance_resource_id](#output_db_instance_resource_id)                            | The RDS Resource ID of this instance                                                    |
| <a name="output_db_instance_status"></a> [db_instance_status](#output_db_instance_status)                                           | The RDS instance status                                                                 |
| <a name="output_db_instance_username"></a> [db_instance_username](#output_db_instance_username)                                     | The master username for the database                                                    |
| <a name="output_db_security_group_id"></a> [db_security_group_id](#output_db_security_group_id)                                     | Security group id for the rds.                                                          |

<!-- END_TF_DOCS -->
