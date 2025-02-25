run "apply_s3_bucket" {
  variables {
    bucket = "my-bucket-xxxxyyyyy1111122223333"
    force_destroy       = true
    object_lock_enabled = true
    tags                = {
      Name = "my-bucket-xxxxyyyyy1111122223333"
    }
    versioning = {
      status = "Enabled"
    }
    server_side_encryption = {
      rule = {
        apply_server_side_encryption_by_default = {
          sse_algorithm     = "AES256"
        }
      }
    }
    intelligent_tiering = {
      status = "Enabled"
      filter = {
        prefix = "/"
      }
      tiering = {
        ARCHIVE_ACCESS = {
          days = 125
        }
        DEEP_ARCHIVE_ACCESS = {
          days = 180
        }
      }
    }
  }
  assert {
    condition     = var.bucket == "my-bucket-xxxxyyyyy1111122223333"
    error_message = "The bucket name must be my-bucket-xxxxyyyyy1111122223333"
  }
}
