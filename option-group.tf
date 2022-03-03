# /* -------------------------------------------------------------------------- */
# /*                           AWS_DB_OPTION_GROUP                              */
# /* -------------------------------------------------------------------------- */
# resource "aws_db_option_group" "this" {
#   count                    = var.is_create_db_instance && var.is_create_option_group_name ? 1 : 0
#   name                     = "${local.identifier}-option"
#   option_group_description = format("Database option group for %s", local.identifier)
#   engine_name              = var.db_option_engine_name
#   major_engine_version     = var.db_option_major_engine_version

#   dynamic "option" {
#     for_each = var.options
#     content {
#       option_name                    = option.value.option_name
#       port                           = lookup(option.value, "port", null)
#       version                        = lookup(option.value, "version", null)
#       db_security_group_memberships  = lookup(option.value, "db_security_group_memberships", null)
#       vpc_security_group_memberships = lookup(option.value, "vpc_security_group_memberships", null)

#       dynamic "option_settings" {
#         for_each = lookup(option.value, "option_settings", [])
#         content {
#           name  = lookup(option_settings.value, "name", null)
#           value = lookup(option_settings.value, "value", null)
#         }
#       }
#     }
#   }

#   tags = merge(local.tags, { Name = "${local.identifier}-option" })

#   lifecycle {
#     create_before_destroy = true
#   }
# }
