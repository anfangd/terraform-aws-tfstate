data "external" "s3_bucket_check" {
  program = ["bash", "${path.module}/scripts/check_s3_bucket.sh", var.bucket_name]
}

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  # bucket_prefix =

  force_destroy       = var.force_destroy
  object_lock_enabled = var.object_lock_enabled
  tags                = var.tags

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
  mfa    = try(var.versioning["mfa"], null)

  versioning_configuration {
    status = try(var.versioning["status"], "Enabled")

    # Valid values: "Enabled" or "Disabled"
    mfa_delete = try(var.versioning["mfa_delete"], null)
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    bucket_key_enabled = try(var.server_side_encryption.bucket_key_enabled, false)

    apply_server_side_encryption_by_default {
      sse_algorithm     = try(var.server_side_encryption.rule.apply_server_side_encryption_by_default.sse_algorithm, "AES256")
      kms_master_key_id = try(var.server_side_encryption.rule.apply_server_side_encryption_by_default.kms_master_key_id, null)
    }
  }

  lifecycle {
    precondition {
      condition     = var.server_side_encryption == null || can(regex("AES256|aws:kms|aws:kms:dsse", var.server_side_encryption.rule.apply_server_side_encryption_by_default.sse_algorithm))
      error_message = "The server side encryption algorithm must be either AES256, aws:kms or aws:kms:dsse"
    }
    precondition {
      condition     = var.server_side_encryption == null || var.server_side_encryption.rule.apply_server_side_encryption_by_default.kms_master_key_id == null || can(length(var.server_side_encryption.rule.apply_server_side_encryption_by_default.kms_master_key_id) > 0)
      error_message = "The KMS master key ID must be specified when the server side encryption algorithm is aws:kms or aws:kms:dsse"
    }
  }
}

# TODO: Implement the following resources
# resource "aws_s3_bucket_lifecycle_configuration" "this" {
#   bucket                                 = aws_s3_bucket.this.id
#   transition_default_minimum_object_size = var.transition_default_minimum_object_size

#   rule {

#   }

#   depends_on = [aws_s3_bucket_versioning.this]
# }

# TODO: Implement the following resources
# resource "aws_s3_bucket_policy" "this" {
#   count = local.attach_policy ? 1 : 0

#   # Chain resources (s3_bucket -> s3_bucket_public_access_block -> s3_bucket_policy )
#   # to prevent "A conflicting conditional operation is currently in progress against this resource."
#   # Ref: https://github.com/hashicorp/terraform-provider-aws/issues/7628

#   bucket = aws_s3_bucket.this.id
#   policy = data.aws_iam_policy_document.combined[0].json

#   depends_on = [
#     aws_s3_bucket_public_access_block.this
#   ]
# }

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
  status = try(tobool(var.intelligent_tiering.status) ? "Enabled" : "Disabled", title(lower(var.intelligent_tiering.status)), null)

  dynamic "filter" {
    for_each = var.intelligent_tiering.filter != null ? [true] : []

    content {
      prefix = try(var.intelligent_tiering.filter.prefix, null)
      tags   = try(var.intelligent_tiering.filter.tags, null)
    }
  }

  dynamic "tiering" {
    for_each = var.intelligent_tiering.tiering

    content {
      access_tier = tiering.key
      days        = tiering.value.days
    }
  }

}

resource "aws_s3_bucket_logging" "this" {
  count = length(var.logging.target_bucket) >= 3 ? 1 : 0

  bucket = aws_s3_bucket.this.id

  target_bucket = var.logging.target_bucket
  target_prefix = var.logging.target_prefix

  lifecycle {
    precondition {
      condition     = can(length(var.logging.target_bucket) > 3)
      error_message = "The target bucket must be at least 3 characters long"
    }
  }
}
