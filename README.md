# terraform-aws-rds

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

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_rds_kms"></a> [rds\_kms](#module\_rds\_kms) | oozou/kms-key/aws | 1.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_option_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_option_group) | resource |
| [aws_db_parameter_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_db_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_iam_role.enhanced_monitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_security_group.client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.additional_client_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.additional_client_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.additional_cluster_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.from_client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.to_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.to_internet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allocated_storage"></a> [allocated\_storage](#input\_allocated\_storage) | The allocated storage in gigabytes | `number` | n/a | yes |
| <a name="input_engine"></a> [engine](#input\_engine) | The database engine to use | `string` | n/a | yes |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | The engine version to use. If auto\_minor\_version\_upgrade is enabled, you can provide a prefix of the version such as 5.7 (for 5.7.10). The actual engine version used is returned in the attribute engine\_version\_actual, defined below. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name used as environment resources name. | `string` | n/a | yes |
| <a name="input_family"></a> [family](#input\_family) | The database family to use | `string` | n/a | yes |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | The instance type of the RDS instance | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name used as a resources name. | `string` | n/a | yes |
| <a name="input_password"></a> [password](#input\_password) | (Required unless a snapshot\_identifier or replicate\_source\_db is provided) Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file. | `string` | n/a | yes |
| <a name="input_port"></a> [port](#input\_port) | The port on which the DB accepts connections. Mostly, postgres=5432, mssql=1433, mariadb=3306 | `number` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix name of customer to be displayed in AWS console and resource. | `string` | n/a | yes |
| <a name="input_username"></a> [username](#input\_username) | (Required unless a snapshot\_identifier or replicate\_source\_db is provided) Username for the master DB user. Cannot be specified for a replica. | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC where to create security group | `string` | n/a | yes |
| <a name="input_additional_client_security_group_egress_rules"></a> [additional\_client\_security\_group\_egress\_rules](#input\_additional\_client\_security\_group\_egress\_rules) | Additional egress rule for client security group. | <pre>list(object({<br>    from_port                = number<br>    to_port                  = number<br>    protocol                 = string<br>    cidr_blocks              = list(string)<br>    source_security_group_id = string<br>    description              = string<br>  }))</pre> | `[]` | no |
| <a name="input_additional_client_security_group_ingress_rules"></a> [additional\_client\_security\_group\_ingress\_rules](#input\_additional\_client\_security\_group\_ingress\_rules) | Additional ingress rule for client security group. | <pre>list(object({<br>    from_port                = number<br>    to_port                  = number<br>    protocol                 = string<br>    cidr_blocks              = list(string)<br>    source_security_group_id = string<br>    description              = string<br>  }))</pre> | `[]` | no |
| <a name="input_additional_cluster_security_group_ingress_rules"></a> [additional\_cluster\_security\_group\_ingress\_rules](#input\_additional\_cluster\_security\_group\_ingress\_rules) | Additional ingress rule for cluster security group. | <pre>list(object({<br>    from_port                = number<br>    to_port                  = number<br>    protocol                 = string<br>    cidr_blocks              = list(string)<br>    source_security_group_id = string<br>    description              = string<br>  }))</pre> | `[]` | no |
| <a name="input_additional_kms_key_policies"></a> [additional\_kms\_key\_policies](#input\_additional\_kms\_key\_policies) | Additional IAM policies block, input as data source. Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document | `list(string)` | `[]` | no |
| <a name="input_allow_major_version_upgrade"></a> [allow\_major\_version\_upgrade](#input\_allow\_major\_version\_upgrade) | Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible | `bool` | `false` | no |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Specifies whether any database modifications are applied immediately, or during the next maintenance window | `bool` | `false` | no |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window | `bool` | `true` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | The AZ for the RDS instance. | `string` | `""` | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | The days to retain backups for. Mostly, for non-production is 7 days and production is 30 days. Default to 7 days | `number` | `30` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance\_window | `string` | `null` | no |
| <a name="input_ca_cert_identifier"></a> [ca\_cert\_identifier](#input\_ca\_cert\_identifier) | The identifier of the CA certificate for the DB instance | `string` | `null` | no |
| <a name="input_copy_tags_to_snapshot"></a> [copy\_tags\_to\_snapshot](#input\_copy\_tags\_to\_snapshot) | On delete, copy all Instance tags to the final snapshot (if final\_snapshot\_identifier is specified) | `bool` | `true` | no |
| <a name="input_custom_tags"></a> [custom\_tags](#input\_custom\_tags) | Tags to add more; default tags contian {terraform=true, environment=var.environment} | `map(string)` | `{}` | no |
| <a name="input_db_option_engine_name"></a> [db\_option\_engine\_name](#input\_db\_option\_engine\_name) | Specifies the name of the engine that this option group should be associated with. If is\_create\_option\_group is set to true this parameter is required. Ref:https://docs.aws.amazon.com/cli/latest/reference/rds/create-option-group.html | `string` | `""` | no |
| <a name="input_db_option_group_name"></a> [db\_option\_group\_name](#input\_db\_option\_group\_name) | if is\_create\_option\_group is false, input existed option group name. If unspecified, the default option group will be used. | `string` | `""` | no |
| <a name="input_db_option_major_engine_version"></a> [db\_option\_major\_engine\_version](#input\_db\_option\_major\_engine\_version) | Database MAJOR engine version, depends on engine type | `string` | `""` | no |
| <a name="input_db_options"></a> [db\_options](#input\_db\_options) | A list of DB options to apply with an option group. Depends on DB engine | <pre>list(object({<br>    db_security_group_memberships  = list(string)<br>    option_name                    = string<br>    port                           = number<br>    version                        = string<br>    vpc_security_group_memberships = list(string)<br><br>    option_settings = list(object({<br>      name  = string<br>      value = string<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_db_parameter_group_name_id"></a> [db\_parameter\_group\_name\_id](#input\_db\_parameter\_group\_name\_id) | if is\_create\_parameter\_group is false, input existed parameter group name id. If unspecified, the default parameter group will be used. | `string` | `null` | no |
| <a name="input_db_subnet_group_name"></a> [db\_subnet\_group\_name](#input\_db\_subnet\_group\_name) | if is\_create\_db\_subnet\_group is false, input existed subnet group name. If unspecified, the default vpc subnet group will be used. | `string` | `""` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | The database can't be deleted when this value is set to true. | `bool` | `false` | no |
| <a name="input_enabled_cloudwatch_logs_exports"></a> [enabled\_cloudwatch\_logs\_exports](#input\_enabled\_cloudwatch\_logs\_exports) | List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine): MySQL and MariaDB: audit, error, general, slowquery. PostgreSQL: postgresql, upgrade. MSSQL: agent , error. Oracle: alert, audit, listener, trace. | `list(string)` | `[]` | no |
| <a name="input_iam_database_authentication_enabled"></a> [iam\_database\_authentication\_enabled](#input\_iam\_database\_authentication\_enabled) | Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled | `string` | `false` | no |
| <a name="input_iops"></a> [iops](#input\_iops) | The amount of provisioned IOPS. Setting this implies a storage\_type of 'io1' | `number` | `0` | no |
| <a name="input_is_create_db_instance"></a> [is\_create\_db\_instance](#input\_is\_create\_db\_instance) | Whether to create db instance or not | `bool` | `true` | no |
| <a name="input_is_create_db_subnet_group"></a> [is\_create\_db\_subnet\_group](#input\_is\_create\_db\_subnet\_group) | Whether to create db subnet group or not | `bool` | `true` | no |
| <a name="input_is_create_option_group"></a> [is\_create\_option\_group](#input\_is\_create\_option\_group) | Whether to create db option group or not (Require for some DB engine) | `bool` | `false` | no |
| <a name="input_is_create_parameter_group"></a> [is\_create\_parameter\_group](#input\_is\_create\_parameter\_group) | Whether to create parameter group or not | `bool` | `true` | no |
| <a name="input_is_create_security_group"></a> [is\_create\_security\_group](#input\_is\_create\_security\_group) | Determines whether to create security group for RDS cluster | `bool` | `true` | no |
| <a name="input_is_enable_monitoring"></a> [is\_enable\_monitoring](#input\_is\_enable\_monitoring) | Whether to enable enhanced monitoring. | `bool` | `false` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN. If storage\_encrypted is set to true and kms\_key\_id is not specified the default KMS key created in your account will be used | `string` | `null` | no |
| <a name="input_license_model"></a> [license\_model](#input\_license\_model) | License model for this DB. Optional, but required for some DB Engines. Valid values: license-included \| bring-your-own-license \| general-public-license | `string` | `""` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00' | `string` | `null` | no |
| <a name="input_max_allocated_storage"></a> [max\_allocated\_storage](#input\_max\_allocated\_storage) | When configured, the upper limit to which Amazon RDS can automatically scale the storage of the DB instance. Must be greater than or equal to allocated\_storage or leave as default to disable Storage Autoscaling | `number` | `0` | no |
| <a name="input_monitoring_interval"></a> [monitoring\_interval](#input\_monitoring\_interval) | The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60. | `number` | `0` | no |
| <a name="input_monitoring_role_arn"></a> [monitoring\_role\_arn](#input\_monitoring\_role\_arn) | The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs. Must be specified if monitoring\_interval is non-zero. If unspecified, terraform will create new role. | `string` | `""` | no |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | Specifies if the RDS instance is multi-AZ | `bool` | `false` | no |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | A list of DB parameter maps to apply | <pre>list(object({<br>    apply_method = string<br>    name         = string<br>    value        = string<br>  }))</pre> | `[]` | no |
| <a name="input_performance_insights_enabled"></a> [performance\_insights\_enabled](#input\_performance\_insights\_enabled) | whether Performance Insights are enabled. | `bool` | `false` | no |
| <a name="input_performance_insights_kms_key_id"></a> [performance\_insights\_kms\_key\_id](#input\_performance\_insights\_kms\_key\_id) | The ARN for the KMS key to encrypt Performance Insights data. Once KMS key is set, it can never be changed. If performance\_insights\_enabled is set to true and performance\_insights\_use\_cmk is set to false and performance\_insights\_kms\_key\_id is not specified the default KMS key in your account will be used | `string` | `null` | no |
| <a name="input_performance_insights_retention_period"></a> [performance\_insights\_retention\_period](#input\_performance\_insights\_retention\_period) | The amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years). | `number` | `null` | no |
| <a name="input_performance_insights_use_cmk"></a> [performance\_insights\_use\_cmk](#input\_performance\_insights\_use\_cmk) | whether Performance Insights encryption using customer managed key(KMS). | `bool` | `false` | no |
| <a name="input_publicly_accessible"></a> [publicly\_accessible](#input\_publicly\_accessible) | Bool to control if instance is publicly accessible | `bool` | `false` | no |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final\_snapshot\_identifier | `bool` | `false` | no |
| <a name="input_snapshot_identifier"></a> [snapshot\_identifier](#input\_snapshot\_identifier) | Specifies whether or not to create this database from a snapshot. This correlates to the snapshot ID you'd find in the RDS console, e.g: rds:production-2015-06-26-06-05. | `string` | `null` | no |
| <a name="input_storage_encrypted"></a> [storage\_encrypted](#input\_storage\_encrypted) | Specifies whether the DB instance is encrypted | `bool` | `true` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'standard' if not. Note that this behaviour is different from the AWS web console, where the default is 'gp2'. | `string` | `"gp2"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of VPC subnet IDs | `list(string)` | `[]` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Updated Terraform resource management timeouts. Applies to `aws_db_instance` in particular to permit resource management times | `map(string)` | <pre>{<br>  "create": "120m",<br>  "delete": "40m",<br>  "update": "80m"<br>}</pre> | no |
| <a name="input_timezone"></a> [timezone](#input\_timezone) | Time zone of the DB instance. timezone is currently only supported by Microsoft SQL Server. The timezone can only be set on creation. See MSSQL User Guide for more information. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_db_client_security_group_id"></a> [db\_client\_security\_group\_id](#output\_db\_client\_security\_group\_id) | Security group id for the rds client. |
| <a name="output_db_instance_address"></a> [db\_instance\_address](#output\_db\_instance\_address) | The address of the RDS instance |
| <a name="output_db_instance_arn"></a> [db\_instance\_arn](#output\_db\_instance\_arn) | The ARN of the RDS instance |
| <a name="output_db_instance_availability_zone"></a> [db\_instance\_availability\_zone](#output\_db\_instance\_availability\_zone) | The availability zone of the RDS instance |
| <a name="output_db_instance_ca_cert_identifier"></a> [db\_instance\_ca\_cert\_identifier](#output\_db\_instance\_ca\_cert\_identifier) | Specifies the identifier of the CA certificate for the DB instance |
| <a name="output_db_instance_domain"></a> [db\_instance\_domain](#output\_db\_instance\_domain) | The ID of the Directory Service Active Directory domain the instance is joined to |
| <a name="output_db_instance_domain_iam_role_name"></a> [db\_instance\_domain\_iam\_role\_name](#output\_db\_instance\_domain\_iam\_role\_name) | The name of the IAM role to be used when making API calls to the Directory Service. |
| <a name="output_db_instance_endpoint"></a> [db\_instance\_endpoint](#output\_db\_instance\_endpoint) | The connection endpoint |
| <a name="output_db_instance_hosted_zone_id"></a> [db\_instance\_hosted\_zone\_id](#output\_db\_instance\_hosted\_zone\_id) | The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record) |
| <a name="output_db_instance_id"></a> [db\_instance\_id](#output\_db\_instance\_id) | The RDS instance ID |
| <a name="output_db_instance_master_password"></a> [db\_instance\_master\_password](#output\_db\_instance\_master\_password) | The master password |
| <a name="output_db_instance_name"></a> [db\_instance\_name](#output\_db\_instance\_name) | The database name |
| <a name="output_db_instance_port"></a> [db\_instance\_port](#output\_db\_instance\_port) | The database port |
| <a name="output_db_instance_resource_id"></a> [db\_instance\_resource\_id](#output\_db\_instance\_resource\_id) | The RDS Resource ID of this instance |
| <a name="output_db_instance_status"></a> [db\_instance\_status](#output\_db\_instance\_status) | The RDS instance status |
| <a name="output_db_instance_username"></a> [db\_instance\_username](#output\_db\_instance\_username) | The master username for the database |
| <a name="output_db_security_group_id"></a> [db\_security\_group\_id](#output\_db\_security\_group\_id) | Security group id for the rds. |
<!-- END_TF_DOCS -->
