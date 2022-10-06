provider "aws" {
  region = "ap-southeast-1"
}

################################################################################
# vpc
################################################################################
module "vpc" {
  source = "git@github.com:oozou/terraform-aws-vpc.git?ref=v1.1.2"

  is_create_vpc = true

  prefix       = "oozou"
  environment  = "test"
  account_mode = "spoke"

  cidr              = "10.105.0.0/16"
  public_subnets    = ["10.105.0.0/24", "10.105.1.0/24", "10.105.2.0/24"]
  private_subnets   = ["10.105.60.0/22", "10.105.64.0/22", "10.105.68.0/22"]
  database_subnets  = ["10.105.20.0/23", "10.105.22.0/23", "10.105.24.0/23"]
  availability_zone = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]

  is_create_nat_gateway             = true
  is_enable_single_nat_gateway      = true
  is_create_flow_log                = false
  is_enable_flow_log_s3_integration = false

  tags = { workspace = "000-oozou-aurora test" }
}


module "rds_mssql" {
  source = "../.."

  prefix      = "oozou"
  name        = "app-mssql"
  environment = "uat"

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
  skip_final_snapshot = true
  deletion_protection = false

  #db instance (logging)
  enabled_cloudwatch_logs_exports = ["agent", "error"]

  #security group
  vpc_id = module.vpc.vpc_id
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
  family = "sqlserver-web-15.0"

  #subnet group
  subnet_ids = module.vpc.database_subnet_ids

  #option group
  is_create_option_group         = true
  db_option_engine_name          = "sqlserver-web"
  db_option_major_engine_version = "15.00"


  custom_tags = {
    "Workspace" : "000-dev"
  }
}
