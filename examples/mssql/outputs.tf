output "db_instance_name" {
  value       = module.rds_mssql.db_instance_name
  description = "DB instance name"
}

output "db_instance_endpoint" {
  value       = module.rds_mssql.db_instance_endpoint
  description = "db instance endpoint"
}

output "db_instance_username" {
  value       = module.rds_mssql.db_instance_username
  description = "DB user name"
  sensitive = true
}