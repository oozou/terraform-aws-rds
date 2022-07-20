/* -------------------------------------------------------------------------- */
/*                                   AWS_KMS                                  */
/* -------------------------------------------------------------------------- */
module "rds_kms" {
  count = var.is_create_db_instance && var.storage_encrypted ? 1 : 0

  source = "git@github.com:oozou/terraform-aws-kms-key.git?ref=v1.0.0"

  prefix               = var.prefix
  name                 = "${local.identifier}-kms"
  environment          = var.environment
  key_type             = "service"
  description          = "Used to encrypt data in ${local.identifier}"
  append_random_suffix = true

  service_key_info = {
    caller_account_ids = [data.aws_caller_identity.this.account_id]
    aws_service_names  = ["rds.${data.aws_region.this.name}.amazonaws.com"]
  }

  additional_policies = var.additional_kms_key_policies

  tags = merge(local.tags, { "Name" : "${local.identifier}-kms" })
}
