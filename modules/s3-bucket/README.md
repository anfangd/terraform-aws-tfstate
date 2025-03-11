# S3 Bucket for tfstate backend

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.83 |
| <a name="requirement_external"></a> [external](#requirement\_external) | >= 2.3.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_external"></a> [external](#provider\_external) | 2.3.4 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.88.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_intelligent_tiering_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_intelligent_tiering_configuration) | resource |
| [aws_s3_bucket_logging.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_ownership_controls.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [external_external.s3_bucket_check](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the bucket | `string` | n/a | yes |
| <a name="input_enable_force_destroy"></a> [enable\_force\_destroy](#input\_enable\_force\_destroy) | A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error | `bool` | `false` | no |
| <a name="input_enable_object_lock"></a> [enable\_object\_lock](#input\_enable\_object\_lock) | A boolean that indicates whether this bucket should have Object Lock enabled | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the bucket | `map(any)` | `{}` | no |
| <a name="input_enable_versioning_mfa_delete"></a> [enable\_versioning\_mfa\_delete](#input\_enable\_versioning\_mfa\_delete) | n/a | `string` | `null` | no |
| <a name="input_versioning_mfa"></a> [versioning\_mfa](#input\_versioning\_mfa) | n/a | `string` | `null` | no |
| <a name="input_sse_algorithm"></a> [sse\_algorithm](#input\_sse\_algorithm) | n/a | `string` | `"AES256"` | no |
| <a name="input_enable_sse_bucket_key"></a> [enable\_sse\_bucket\_key](#input\_enable\_sse\_bucket\_key) | n/a | `bool` | `false` | no |
| <a name="input_sse_kms_master_key_id"></a> [sse\_kms\_master\_key\_id](#input\_sse\_kms\_master\_key\_id) | n/a | `string` | `null` | no |
| <a name="input_enable_inteligent_tiering"></a> [enable\_inteligent\_tiering](#input\_enable\_inteligent\_tiering) | n/a | `string` | `"Enabled"` | no |
| <a name="input_tiering"></a> [tiering](#input\_tiering) | n/a | `map(any)` | <pre>{<br/>  "ARCHIVE_ACCESS": {<br/>    "days": 125<br/>  },<br/>  "DEEP_ARCHIVE_ACCESS": {<br/>    "days": 180<br/>  }<br/>}</pre> | no |
| <a name="input_logging_target_bucket"></a> [logging\_target\_bucket](#input\_logging\_target\_bucket) | n/a | `string` | `null` | no |
| <a name="input_logging_target_prefix"></a> [logging\_target\_prefix](#input\_logging\_target\_prefix) | n/a | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket"></a> [bucket](#output\_bucket) | output of s3 bucket |
| <a name="output_versioning"></a> [versioning](#output\_versioning) | output of s3 bucket versioning |
| <a name="output_server_side_encryption"></a> [server\_side\_encryption](#output\_server\_side\_encryption) | output of s3 bucket server side encryption |
| <a name="output_public_access_block"></a> [public\_access\_block](#output\_public\_access\_block) | output of s3 bucket public access block |
| <a name="output_ownership_controls"></a> [ownership\_controls](#output\_ownership\_controls) | output of s3 bucket ownership controls |
| <a name="output_intelligent_tiering"></a> [intelligent\_tiering](#output\_intelligent\_tiering) | output of s3 bucket intelligent tiering |
| <a name="output_logging"></a> [logging](#output\_logging) | output of s3 bucket logging |
<!-- END_TF_DOCS -->
