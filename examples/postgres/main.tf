provider "aws" {
  region = "us-east-2"
}

module "rds_postgres" {
  source = "../.."

  prefix      = "oozou"
  name        = "app-postgres"
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
  vpc_id = "vpc-xxxxxx"
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
      source_security_group_id = ""
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
  subnet_ids = ["subnet-xxx", "subnet-xxxx"]

  custom_tags = {
    "Workspace" : "000-dev"
  }
}