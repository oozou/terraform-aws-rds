# Change Log

All notable changes to this module will be documented in this file.

## [2.1.2] - 2025-04-08
### Updated

- update db identifier in DB alarms and event

## [2.1.1] - 2025-04-08
### Updated

- remove time stamp in the final snapshot name

## [2.1.0] - 2025-04-01
### Added

- add secret manager resource for storing the db master username/password
- add kms resource to encrypt the secret manager

## [2.0.0] - 2025-03-31
### Changed

- update output aws_db_instance.name to aws_db_instance.db_name
- upgrade aws provider to >= 5.0.0

## [1.0.10] - 2023-07-10

### Added

- Add log group encryption with related resources
  - Data `os_access_cloudwatch_policy.cloudwatch_log_group_kms_policy`
  - Module `cloudwatch_log_group_kms`
- Add data source `aws_region.this` and `aws_caller_identity.this`
- Add `local.cloudwatch_log_group_kms_key_arn` to control logic selecting KMS key arn

### Changed

- Update submodule `vpn_connection` parameter
  - Add `var.is_create_default_kms`
  - Rename `var.cloudwatch_log_kms_key_id` to `var.cloudwatch_log_group_kms_key_arn`

## [1.0.9] - 2023-01-05

### Added

- variables
  - is_enable_internet_access: option to enable/disable the outbound internet access, disable by default.


## [1.0.8] - 2022-12-22

### Changed

- Add alarm.tf with default and custom RDS alarms
- Add following vars
    - is_enable_default_alarms
    - default_alarm_actions
    - default_ok_actions
    - custom_rds_alarms_configure
    - event_categories

## [1.0.7] - 2022-12-08

### Changed

- Update module `rds_kms` argument:
    - `name` from `${local.identifier}-kms` to `${var.name}-db`
    - `tags` remove `{ "Name" : "${local.identifier}-kms" }`

## [1.0.6] - 2022-10-07

### Changed

- support create log group by terraform

## [1.0.5] - 2022-09-21

### Changed

- KMS module use from public repository

## [1.0.4] - 2022-07-22

### Changed

- Add `var.additional_kms_key_policies` for RDS KMS
- Upgrade KMS module version to 1.0.0
- Change data `aws_caller_identity.main` and `aws_region.active` to `XXX.this`

## [1.0.3] - 2022-07-18

### Changed

- variables.tf
  - storage_encrypted default value change from false to true

## [1.0.2] - 2022-04-22

### Added

- variables
  - KMS that create by this module will come with tag

## [1.0.1] - 2022-04-18

### Added

- add cluster additional ingress rule 

## [1.0.0] - 2022-03-04

### Added

- Initial release for terraform-aws-rds module.
