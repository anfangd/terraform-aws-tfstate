#


cf. [Amazon DynamoDB でサポートされるデータ型と命名規則 - Amazon DynamoDB](https://docs.aws.amazon.com/ja_jp/amazondynamodb/latest/developerguide/HowItWorks.NamingRulesDataTypes.html)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.83 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.88.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_policy_name"></a> [policy\_name](#input\_policy\_name) | The name of the IAM policy | `string` | `""` | no |
| <a name="input_s3"></a> [s3](#input\_s3) | List of S3 bucket to allow access | <pre>list(object({<br/>    bucket_name = string           # The bucket name to allow access<br/>    key_prefix  = optional(string) # The key prefix to allow access<br/>  }))</pre> | <pre>[<br/>  {<br/>    "bucket_name": ""<br/>  }<br/>]</pre> | no |
| <a name="input_dynamodb"></a> [dynamodb](#input\_dynamodb) | The DynamoDB table to allow access | <pre>list(object({<br/>    table_arn = string # The ARN of the DynamoDB table to allow access<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_policy"></a> [policy](#output\_policy) | The IAM policy |
<!-- END_TF_DOCS -->
