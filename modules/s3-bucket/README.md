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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.88.0 |
| <a name="provider_external"></a> [external](#provider\_external) | 2.3.4 |

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
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error | `bool` | `false` | no |
| <a name="input_intelligent_tiering"></a> [intelligent\_tiering](#input\_intelligent\_tiering) | A mapping of tags to assign to the bucket | <pre>object({<br/>    status = optional(string)<br/>    filter = optional(object({<br/>      prefix = optional(string)<br/>      tags   = optional(map(string))<br/>    }))<br/>    tiering = map(any)<br/>  })</pre> | <pre>{<br/>  "status": "Enabled",<br/>  "tiering": {<br/>    "ARCHIVE_ACCESS": {<br/>      "days": 125<br/>    },<br/>    "DEEP_ARCHIVE_ACCESS": {<br/>      "days": 180<br/>    }<br/>  }<br/>}</pre> | no |
| <a name="input_logging"></a> [logging](#input\_logging) | A mapping of logging configuration | <pre>object({<br/>    target_bucket = string<br/>    target_prefix = optional(string)<br/>  })</pre> | <pre>{<br/>  "target_bucket": ""<br/>}</pre> | no |
| <a name="input_object_lock_enabled"></a> [object\_lock\_enabled](#input\_object\_lock\_enabled) | A boolean that indicates whether this bucket should have Object Lock enabled | `bool` | `false` | no |
| <a name="input_server_side_encryption"></a> [server\_side\_encryption](#input\_server\_side\_encryption) | A mapping of server side encryption configuration | <pre>object({<br/>    rule = object({<br/>      bucket_key_enabled = optional(bool)<br/>      apply_server_side_encryption_by_default = optional(object({<br/>        sse_algorithm     = string<br/>        kms_master_key_id = optional(string)<br/>      }))<br/>    })<br/>  })</pre> | <pre>{<br/>  "rule": {<br/>    "apply_server_side_encryption_by_default": {<br/>      "sse_algorithm": "AES256"<br/>    },<br/>    "bucket_key_enabled": false<br/>  }<br/>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the bucket | `map(any)` | `{}` | no |
| <a name="input_versioning"></a> [versioning](#input\_versioning) | A mapping of versioning configuration | <pre>object({<br/>    mfa        = optional(string)<br/>    status     = string<br/>    mfa_delete = optional(string)<br/>  })</pre> | <pre>{<br/>  "status": "Enabled"<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket"></a> [bucket](#output\_bucket) | output of s3 bucket |
| <a name="output_intelligent_tiering"></a> [intelligent\_tiering](#output\_intelligent\_tiering) | output of s3 bucket intelligent tiering |
| <a name="output_logging"></a> [logging](#output\_logging) | output of s3 bucket logging |
| <a name="output_ownership_controls"></a> [ownership\_controls](#output\_ownership\_controls) | output of s3 bucket ownership controls |
| <a name="output_public_access_block"></a> [public\_access\_block](#output\_public\_access\_block) | output of s3 bucket public access block |
| <a name="output_server_side_encryption"></a> [server\_side\_encryption](#output\_server\_side\_encryption) | output of s3 bucket server side encryption |
| <a name="output_versioning"></a> [versioning](#output\_versioning) | output of s3 bucket versioning |
<!-- END_TF_DOCS -->
