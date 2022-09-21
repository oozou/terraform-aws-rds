# Change Log

All notable changes to this module will be documented in this file.

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
