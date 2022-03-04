/* -------------------------------------------------------------------------- */
/*                               MONITORING ROLE                              */
/* -------------------------------------------------------------------------- */
resource "aws_iam_role" "enhanced_monitoring" {
  count = var.is_create_db_instance && var.is_enable_monitoring ? 1 : 0
  name  = format("%s-monitoring-role", local.identifier)
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"]

  tags = merge(local.tags, { "Name" : format("%s-monitoring-role", local.identifier) })
}
