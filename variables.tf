/* -------------------------------------------------------------------------- */
/*                                  GENERICS                                  */
/* -------------------------------------------------------------------------- */
variable "prefix" {
  description = "The prefix name of customer to be displayed in AWS console and resource."
  type        = string
}

variable "name" {
  description = "Name used as a resources name."
  type        = string
}

variable "environment" {
  description = "Environment name used as environment resources name."
  type        = string
}

variable "custom_tags" {
  description = "Tags to add more; default tags contian {terraform=true, environment=var.environment}"
  type        = map(string)
  default     = {}
}

/* -------------------------------------------------------------------------- */
/*                               AWS_DB_INSTACE                               */
/* -------------------------------------------------------------------------- */
variable "is_create_db_instance" {
  description = "Whether to create db instance or not"
  type        = bool
  default     = true
}

/* -------------------------------------------------------------------------- */
/*                           AWS_DB_INSTACE (server)                          */
/* -------------------------------------------------------------------------- */
variable "engine" {
  description = "The database engine to use"
  type        = string
}

variable "engine_version" {
  description = "The engine version to use. If auto_minor_version_upgrade is enabled, you can provide a prefix of the version such as 5.7 (for 5.7.10). The actual engine version used is returned in the attribute engine_version_actual, defined below."
  type        = string
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
}

variable "license_model" {
  type        = string
  description = "License model for this DB. Optional, but required for some DB Engines. Valid values: license-included | bring-your-own-license | general-public-license"
  default     = ""
}

variable "ca_cert_identifier" {
  type        = string
  description = "The identifier of the CA certificate for the DB instance"
  default     = null
}

variable "timezone" {
  description = "Time zone of the DB instance. timezone is currently only supported by Microsoft SQL Server. The timezone can only be set on creation. See MSSQL User Guide for more information."
  type        = string
  default     = ""
}

variable "timeouts" {
  description = "Updated Terraform resource management timeouts. Applies to `aws_db_instance` in particular to permit resource management times"
  type        = map(string)
  default = {
    create = "120m"
    update = "80m"
    delete = "40m"
  }
}

/* -------------------------------------------------------------------------- */
/*                           AWS_DB_INSTACE (storage)                         */
/* -------------------------------------------------------------------------- */

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
}

variable "storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'standard' if not. Note that this behaviour is different from the AWS web console, where the default is 'gp2'."
  type        = string
  default     = "gp2"
}

variable "iops" {
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of 'io1'"
  type        = number
  default     = 0
}

variable "max_allocated_storage" {
  description = "When configured, the upper limit to which Amazon RDS can automatically scale the storage of the DB instance. Must be greater than or equal to allocated_storage or leave as default to disable Storage Autoscaling"
  type        = number
  default     = 0
}

/* ------------------------------- encryption ------------------------------- */
variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
  default     = false
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN. If storage_encrypted is set to true and kms_key_id is not specified the default KMS key created in your account will be used"
  type        = string
  default     = null
}


/* -------------------------------------------------------------------------- */
/*                           AWS_DB_INSTACE (schema)                          */
/* -------------------------------------------------------------------------- */
variable "username" {
  description = "(Required unless a snapshot_identifier or replicate_source_db is provided) Username for the master DB user. Cannot be specified for a replica."
  type        = string
}

variable "password" {
  description = "(Required unless a snapshot_identifier or replicate_source_db is provided) Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file."
  type        = string
}

variable "port" {
  description = "The port on which the DB accepts connections. Mostly, postgres=5432, mssql=1433, mariadb=3306"
  type        = number
}

variable "iam_database_authentication_enabled" {
  description = "Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled"
  type        = string
  default     = false
}

/* -------------------------------------------------------------------------- */
/*                       AWS_DB_INSTACE (create from snapshot)                */
/* -------------------------------------------------------------------------- */
variable "snapshot_identifier" {
  description = "Specifies whether or not to create this database from a snapshot. This correlates to the snapshot ID you'd find in the RDS console, e.g: rds:production-2015-06-26-06-05."
  type        = string
  default     = null
}

/* -------------------------------------------------------------------------- */
/*                       AWS_DB_INSTACE (networking)                          */
/* -------------------------------------------------------------------------- */

variable "availability_zone" {
  description = "The AZ for the RDS instance."
  type        = string
  default     = ""
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}

variable "publicly_accessible" {
  description = "Bool to control if instance is publicly accessible"
  type        = bool
  default     = false
}

/* -------------------------------------------------------------------------- */
/*                       AWS_DB_INSTACE (monitoring)                          */
/* -------------------------------------------------------------------------- */

variable "is_enable_monitoring" {
  description = "Whether to enable enhanced monitoring."
  type        = bool
  default     = false
}

variable "monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60."
  type        = number
  default     = 0
}

variable "monitoring_role_arn" {
  description = "The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs. Must be specified if monitoring_interval is non-zero. If unspecified, terraform will create new role."
  type        = string
  default     = ""
}

variable "performance_insights_enabled" {
  description = "whether Performance Insights are enabled."
  type        = bool
  default     = false
}

variable "performance_insights_use_cmk" {
  description = "whether Performance Insights encryption using customer managed key(KMS)."
  type        = bool
  default     = false
}

variable "performance_insights_kms_key_id" {
  description = "The ARN for the KMS key to encrypt Performance Insights data. Once KMS key is set, it can never be changed. If performance_insights_enabled is set to true and performance_insights_use_cmk is set to false and performance_insights_kms_key_id is not specified the default KMS key in your account will be used"
  type        = string
  default     = null
}

variable "performance_insights_retention_period" {
  type        = number
  default     = null
  description = "The amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years)."
}

/* -------------------------------------------------------------------------- */
/*                         AWS_DB_INSTACE (backup)                            */
/* -------------------------------------------------------------------------- */
variable "backup_retention_period" {
  description = "The days to retain backups for. Mostly, for non-production is 7 days and production is 30 days. Default to 7 days"
  type        = number
  default     = 30
}

variable "backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
  type        = string
  default     = null
}

variable "maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  type        = string
  default     = null
}


/* -------------------------------------------------------------------------- */
/*                   AWS_DB_INSTACE (additional config)                       */
/* -------------------------------------------------------------------------- */
variable "allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible"
  type        = bool
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
  type        = bool
  default     = true
}

variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier"
  type        = bool
  default     = false
}

variable "copy_tags_to_snapshot" {
  description = "On delete, copy all Instance tags to the final snapshot (if final_snapshot_identifier is specified)"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "The database can't be deleted when this value is set to true."
  type        = bool
  default     = false
}

/* -------------------------------------------------------------------------- */
/*                           AWS_DB_INSTACE (logging)                         */
/* -------------------------------------------------------------------------- */

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine): MySQL and MariaDB: audit, error, general, slowquery. PostgreSQL: postgresql, upgrade. MSSQL: agent , error. Oracle: alert, audit, listener, trace."
  type        = list(string)
  default     = []
}

/* -------------------------------------------------------------------------- */
/*                               SECURITY GROUP                               */
/* -------------------------------------------------------------------------- */
variable "is_create_security_group" {
  description = "Determines whether to create security group for RDS cluster"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "ID of the VPC where to create security group"
  type        = string
}

variable "additional_cluster_security_group_ingress_rules" {
  type = list(object({
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = list(string)
    source_security_group_id = string
    description              = string
  }))
  description = "Additional ingress rule for cluster security group."
  default     = []
}

/* -------------------------------------------------------------------------- */
/*                        CLIENT SECURITY GROUP                               */
/* -------------------------------------------------------------------------- */
variable "additional_client_security_group_ingress_rules" {
  type = list(object({
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = list(string)
    source_security_group_id = string
    description              = string
  }))
  description = "Additional ingress rule for client security group."
  default     = []
}

variable "additional_client_security_group_egress_rules" {
  type = list(object({
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = list(string)
    source_security_group_id = string
    description              = string
  }))
  description = "Additional egress rule for client security group."
  default     = []
}

/* -------------------------------------------------------------------------- */
/*                            PARAMETER_GROUP_NAME                            */
/* -------------------------------------------------------------------------- */
variable "is_create_parameter_group" {
  description = "Whether to create parameter group or not"
  type        = bool
  default     = true
}

variable "db_parameter_group_name_id" {
  description = "if is_create_parameter_group is false, input existed parameter group name id. If unspecified, the default parameter group will be used."
  type        = string
  default     = null
}

variable "family" {
  description = "The database family to use"
  type        = string
}

variable "parameters" {
  description = "A list of DB parameter maps to apply"
  type = list(object({
    apply_method = string
    name         = string
    value        = string
  }))
  default = []
}

/* -------------------------------------------------------------------------- */
/*                               DB_SUBNET_GROUP                              */
/* -------------------------------------------------------------------------- */
variable "is_create_db_subnet_group" {
  description = "Whether to create db subnet group or not"
  type        = bool
  default     = true
}

variable "db_subnet_group_name" {
  description = "if is_create_db_subnet_group is false, input existed subnet group name. If unspecified, the default vpc subnet group will be used."
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "A list of VPC subnet IDs"
  type        = list(string)
  default     = []
}

# /* -------------------------------------------------------------------------- */
# /*                               DB_OPTION_GROUP                              */
# /* -------------------------------------------------------------------------- */
variable "is_create_option_group" {
  description = "Whether to create db option group or not (Require for some DB engine)"
  type        = bool
  default     = false
}

variable "db_option_group_name" {
  description = "if is_create_option_group is false, input existed option group name. If unspecified, the default option group will be used."
  type        = string
  default     = ""
}

variable "db_option_engine_name" {
  description = "Specifies the name of the engine that this option group should be associated with. If is_create_option_group is set to true this parameter is required. Ref:https://docs.aws.amazon.com/cli/latest/reference/rds/create-option-group.html"
  type        = string
  default     = ""
}

variable "db_option_major_engine_version" {
  type        = string
  description = "Database MAJOR engine version, depends on engine type"
  default     = ""
  # https://docs.aws.amazon.com/cli/latest/reference/rds/create-option-group.html
}

variable "db_options" {
  type = list(object({
    db_security_group_memberships  = list(string)
    option_name                    = string
    port                           = number
    version                        = string
    vpc_security_group_memberships = list(string)

    option_settings = list(object({
      name  = string
      value = string
    }))
  }))

  default     = []
  description = "A list of DB options to apply with an option group. Depends on DB engine"
}
