/* -------------------------------------------------------------------------- */
/*                                   AWS_KMS                                  */
/* -------------------------------------------------------------------------- */
module "rds_kms" {
  count = var.is_create_db_instance && var.storage_encrypted ? 1 : 0

  source      = "git@github.com:oozou/terraform-aws-kms-key.git?ref=v0.0.1"
  key_type    = "service"
  description = "Used to encrypt data in ${local.identifier}"
  alias_name  = "${local.identifier}-kms"
}
