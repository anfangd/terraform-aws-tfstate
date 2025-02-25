provider "aws" {
  region = "us-west-2"
}

run "test_bucket_default" {
  command = plan
  variables {
    bucket = "my-bucket"
    # force_destroy       = false
    # object_lock_enabled = false
    # tags                = {}
    # versioning = {
    #   status = "Enabled"
    # }
    # server_side_encryption = {
    #   rule = {
    #     bucket_key_enabled = false
    #     apply_server_side_encryption_by_default = {
    #       sse_algorithm = "AES256"
    #     }
    #   }
    # }
    # transition_default_minimum_object_size = "all_storage_classes_128K"
    # lifecycle_rules                        = []
    # intelligent_tiering = {
    #   status = "Enabled"
    #   filter = {
    #     prefix = "/"
    #   }
    #   tiering = {
    #     ARCHIVE_ACCESS = {
    #       days = 30
    #     }
    #     DEEP_ARCHIVE_ACCESS = {
    #       days = 90
    #     }
    #   }
    # }
  }
  assert {
    condition     = var.bucket == "my-bucket"
    error_message = "The bucket name must be my-bucket"
  }
}

run "test_bucket_custom_1" {
  command = plan
  variables {
    bucket = "my-bucket"
    force_destroy       = true
    object_lock_enabled = true
    tags                = {
      Name = "my-bucket"
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
    # transition_default_minimum_object_size = "all_storage_classes_128K"
    # lifecycle_rules                        = []
    intelligent_tiering = {
      status = "Enabled"
      filter = {
        prefix = "/"
        tags   = {
          Name = "my-bucket"
        }
      }
      tiering = {
        ARCHIVE_ACCESS = {
          days = 30
        }
        DEEP_ARCHIVE_ACCESS = {
          days = 90
        }
      }
    }
  }
  assert {
    condition     = var.bucket == "my-bucket"
    error_message = "The bucket name must be my-bucket"
  }
}

run "test_bucket_error_1" {
  command = plan
  variables {
    bucket = ""
  }
  expect_failures = [var.bucket]
}

run "test_bucket_error_2" {
  command = plan
  variables {
    bucket = join("", [for i in range(64) : "x"])
  }
  expect_failures = [var.bucket]
}

run "test_null_error_1" {
  command = plan
  variables {
    bucket = null
    force_destroy = null
    object_lock_enabled = null
    tags = null
    versioning = {
      status = null
    }
    server_side_encryption = null
  }
  expect_failures = [
    var.bucket,
  ]
}
