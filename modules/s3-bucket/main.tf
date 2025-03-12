data "external" "s3_bucket_check" {
  program = ["bash", "${path.module}/scripts/check_s3_bucket.sh", var.bucket_name]
}

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  # bucket_prefix =

  force_destroy = var.enable_force_destroy
  tags          = var.tags

  lifecycle {
    precondition {
      condition     = !(data.external.s3_bucket_check.result["exists"] == true && data.external.s3_bucket_check.result["status"] == "403")
      error_message = "The S3 bucket name '${var.bucket_name}' already exists. Please choose a different name."
    }
  }
}

# MEMO: This module is not support S3 bucket ACL because it is DUPLICATED.
# resource "aws_s3_bucket_acl" "this" {
#   bucket = aws_s3_bucket.this.id
#   acl    = "private"
#
#   depends_on = [aws_s3_bucket_ownership_controls.this]
# }

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  mfa    = try(var.versioning_mfa, null)

  versioning_configuration {
    status = "Enabled"

    # Valid values: "Enabled" or "Disabled"
    mfa_delete = var.enable_versioning_mfa_delete ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_object_lock_configuration" "this" {
  bucket              = aws_s3_bucket.this.id
  object_lock_enabled = try(var.enable_object_lock, false) == false ? null : "Enabled" # Valid values: Enabled.

  rule {
    default_retention {
      mode  = var.object_lock_mode # Valid values: COMPLIANCE, GOVERNANCE.
      days  = var.object_lock_days
      years = var.object_lock_years
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    bucket_key_enabled = try(var.enable_sse_bucket_key, false)

    apply_server_side_encryption_by_default {
      sse_algorithm     = try(var.sse_algorithm, "AES256")
      kms_master_key_id = try(var.sse_kms_master_key_id, null)
    }
  }

  lifecycle {
    precondition {
      condition     = can(regex("AES256|aws:kms|aws:kms:dsse", var.sse_algorithm))
      error_message = "The server side encryption algorithm must be either AES256, aws:kms or aws:kms:dsse"
    }
    precondition {
      condition     = var.sse_kms_master_key_id == null || can(length(var.sse_kms_master_key_id) > 0)
      error_message = "The KMS master key ID must be specified when the server side encryption algorithm is aws:kms or aws:kms:dsse"
    }
  }
}

# MEMO: This module uses inteligent tiering instead of lifecycle.
# resource "aws_s3_bucket_lifecycle_configuration" "this" {}

# MEMO: This module DOES NOT create S3 Bucket Policy.
# resource "aws_s3_bucket_policy" "this" {}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }

  # This `depends_on` is to prevent "A conflicting conditional operation is currently in progress against this resource."
  depends_on = [
    # aws_s3_bucket_policy.this,
    aws_s3_bucket_public_access_block.this,
    aws_s3_bucket.this
  ]
}

resource "aws_s3_bucket_intelligent_tiering_configuration" "this" {
  name   = aws_s3_bucket.this.id
  bucket = aws_s3_bucket.this.id
  status = var.enable_inteligent_tiering ? "Enabled" : "Disabled"

  # MEMO: This module DOES NOT implement filter
  # filter {{}

  dynamic "tiering" {
    for_each = var.tiering

    content {
      access_tier = tiering.key
      days        = tiering.value.days
    }
  }
}

resource "aws_s3_bucket_logging" "this" {
  count = length(var.logging_target_bucket) >= 3 ? 1 : 0

  bucket = aws_s3_bucket.this.id

  target_bucket = var.logging_target_bucket
  target_prefix = var.logging_target_prefix

  lifecycle {
    precondition {
      condition     = can(length(var.logging_target_bucket) > 3)
      error_message = "The target bucket must be at least 3 characters long"
    }
  }
}
