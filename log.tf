data "aws_iam_policy_document" "cloudwatch_log_group_kms_policy" {
  statement {
    sid = "AllowCloudWatchToDoCryptography"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = tolist([format("logs.%s.amazonaws.com", data.aws_region.this.name)])
    }

    condition {
      test     = "ArnEquals"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values   = formatlist("arn:aws:logs:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:log-group:/aws/rds/instance/${local.identifier}/%s:*", var.enabled_cloudwatch_logs_exports)
    }
  }
}

module "cloudwatch_log_group_kms" {
  count   = var.is_create_db_instance && var.is_create_default_kms && var.cloudwatch_log_kms_key_arn == null ? 1 : 0
  source  = "oozou/kms-key/aws"
  version = "1.0.0"

  prefix               = var.prefix
  environment          = var.environment
  name                 = format("%s-log-group", var.name)
  key_type             = "service"
  append_random_suffix = true
  description          = format("Secure Secrets Manager's service secrets for service %s", local.identifier)
  additional_policies  = [data.aws_iam_policy_document.cloudwatch_log_group_kms_policy.json]

  tags = merge(local.tags, { "Name" : format("%s-log-group", local.identifier) })
}

resource "aws_cloudwatch_log_group" "this" {
  count = var.is_create_db_instance ? length(var.enabled_cloudwatch_logs_exports) : 0

  name              = format("/aws/rds/instance/%s/%s", local.identifier, var.enabled_cloudwatch_logs_exports[count.index])
  retention_in_days = var.cloudwatch_log_retention_in_days
  kms_key_id        = local.cloudwatch_log_group_kms_key_arn

  tags = local.tags
}
