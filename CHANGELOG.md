# Change Log

All notable changes to this module will be documented in this file.

## [1.0.8] - 2023-01-05

### Added

- variables
  - is_enable_internet_access: option to enable/disable the outbound internet access, disable by default.

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
