output "s3" {
  description = "output of s3 bucket"
  value = {
    bucket                 = module.s3.bucket
    versioning             = module.s3.versioning
    server_side_encryption = module.s3.server_side_encryption
    public_access_block    = module.s3.public_access_block
    ownership_controls     = module.s3.ownership_controls
    intelligent_tiering    = module.s3.intelligent_tiering
    logging                = module.s3.logging
  }
}

output "dynamodb" {
  description = "output of dynamodb"
  value = {
    arn          = try(aws_dynamodb_table.this[0].arn, null)
    id           = try(aws_dynamodb_table.this[0].id, null)
    replica      = try(aws_dynamodb_table.this[0].replica, null)
    stream_arn   = try(aws_dynamodb_table.this[0].stream_arn, null)
    stream_label = try(aws_dynamodb_table.this[0].stream_label, null)
    tags_all     = try(aws_dynamodb_table.this[0].tags_all, null)
  }
}

output "iam" {
  description = "output of iam policy"
  value = {
    policy = module.iam_policy
  }
}
