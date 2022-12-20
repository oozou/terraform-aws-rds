module "custom_rds_alarms" {
  source  = "oozou/cloudwatch-alarm/aws"
  version = "1.0.0"

  for_each =  var.is_create_db_instance ? var.custom_rds_alarms_configure :{}
  depends_on = [aws_db_instance.this[0]]

  prefix      = var.prefix
  environment = var.environment
  name        = format("%s-%s-alarm", local.identifier, each.key)

  alarm_description = format(
    "%s's %s %s %s in period %ss with %s datapoint",
    lookup(each.value, "metric_name", null),
    lookup(each.value, "statistic", "Average"),
    lookup(each.value, "comparison_operator", null),
    lookup(each.value, "threshold", null),
    lookup(each.value, "period", 600),
    lookup(each.value, "evaluation_periods", 1)
  )

  comparison_operator = local.comparison_operators[lookup(each.value, "comparison_operator", null)]
  evaluation_periods  = lookup(each.value, "evaluation_periods", 1)
  metric_name         = lookup(each.value, "metric_name", null)
  namespace           = "AWS/RDS"
  period              = lookup(each.value, "period", 600)
  statistic           = lookup(each.value, "statistic", "Average")
  threshold           = lookup(each.value, "threshold", null)

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.this[0].id
  }

  alarm_actions = lookup(each.value, "alarm_actions", null)
  ok_actions = lookup(each.value, "ok_actions", null)
  # TODO set this to alrm to resource

  tags = local.tags
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_too_high" {
  count = var.is_create_db_instance && var.is_enable_default_alarms ? 1 : 0
  alarm_name          = format("%s-%s-alarm", local.identifier, "cpu_utilization_too_high")
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Average database CPU utilization over last 10 minutes too high"
  alarm_actions       = var.default_alarm_actions
  ok_actions          = var.default_ok_actions

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.this[0].id
  }
}

resource "aws_cloudwatch_metric_alarm" "freeable_memory_too_low" {
  count = var.is_create_db_instance && var.is_enable_default_alarms ? 1 : 0
  alarm_name          = format("%s-%s-alarm", local.identifier, "freeable_memory_too_low")
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = 128000000
  alarm_description   = "Average database freeable memory over last 10 minutes too low, performance may suffer"
  alarm_actions       = var.default_alarm_actions
  ok_actions          = var.default_ok_actions

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.this[0].id
  }
}

resource "aws_cloudwatch_metric_alarm" "free_storage_space_too_low" {
  count = var.is_create_db_instance && var.is_enable_default_alarms ? 1 : 0
  alarm_name          =  format("%s-%s-alarm", local.identifier, "free_storage_space_threshold")
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = var.max_allocated_storage*0.1
  alarm_description   = "Average database free storage space over last 10 minutes too low"
  alarm_actions       = var.default_alarm_actions
  ok_actions          = var.default_ok_actions

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.this[0].id
  }
}

resource "aws_db_event_subscription" "default" {
  for_each     = var.is_create_db_instance && var.is_enable_default_alarms ? toset(var.default_alarm_actions)  : []
  name      =  format("%s-%s-subscription", local.identifier, element(split(":", each.value),length(split(":", each.value)) - 1))
  sns_topic = each.value

  source_type = "db-instance"
  source_ids  = [aws_db_instance.this[0].id]

  event_categories = var.event_categories

}
