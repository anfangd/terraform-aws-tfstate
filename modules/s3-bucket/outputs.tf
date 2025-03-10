output "bucket" {
  description = "output of s3 bucket"
  value = {
    arn      = aws_s3_bucket.this.arn
    id       = aws_s3_bucket.this.id
    region   = aws_s3_bucket.this.region
    tags_all = aws_s3_bucket.this.tags_all
  }
}

output "versioning" {
  description = "output of s3 bucket versioning"
  value = {
    bucket = aws_s3_bucket_versioning.this.bucket
    mfa    = aws_s3_bucket_versioning.this.mfa
    status = aws_s3_bucket_versioning.this.versioning_configuration[0].status
  }
}

output "server_side_encryption" {
  description = "output of s3 bucket server side encryption"
  value = {
    bucket                = aws_s3_bucket_server_side_encryption_configuration.this.bucket
    expected_bucket_owner = aws_s3_bucket_server_side_encryption_configuration.this.expected_bucket_owner
    rule                  = aws_s3_bucket_server_side_encryption_configuration.this.rule
  }
}

output "public_access_block" {
  description = "output of s3 bucket public access block"
  value = {
    bucket                  = aws_s3_bucket_public_access_block.this.bucket
    block_public_acls       = aws_s3_bucket_public_access_block.this.block_public_acls
    block_public_policy     = aws_s3_bucket_public_access_block.this.block_public_policy
    ignore_public_acls      = aws_s3_bucket_public_access_block.this.ignore_public_acls
    restrict_public_buckets = aws_s3_bucket_public_access_block.this.restrict_public_buckets
  }
}

output "ownership_controls" {
  description = "output of s3 bucket ownership controls"
  value = {
    bucket = aws_s3_bucket_ownership_controls.this.bucket
    rules  = aws_s3_bucket_ownership_controls.this.rule
  }
}

output "intelligent_tiering" {
  description = "output of s3 bucket intelligent tiering"
  value = {
    bucket  = aws_s3_bucket_intelligent_tiering_configuration.this.bucket
    status  = aws_s3_bucket_intelligent_tiering_configuration.this.status
    filter  = aws_s3_bucket_intelligent_tiering_configuration.this.filter
    tiering = aws_s3_bucket_intelligent_tiering_configuration.this.tiering
  }
}

output "logging" {
  description = "output of s3 bucket logging"
  value = {
    bucket                   = try(aws_s3_bucket_logging.this[0].bucket, null)
    expected_bucket_owner    = try(aws_s3_bucket_logging.this[0].expected_bucket_owner, null)
    target_bucket            = try(aws_s3_bucket_logging.this[0].target_bucket, null)
    target_prefix            = try(aws_s3_bucket_logging.this[0].target_prefix, null)
    target_grant             = try(aws_s3_bucket_logging.this[0].target_grant, null)
    target_object_key_format = try(aws_s3_bucket_logging.this[0].target_object_key_format, null)
  }
}
