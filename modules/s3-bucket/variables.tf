variable "bucket" {
  description = "The name of the bucket"
  type        = string
  nullable    = false
  default     = ""

  validation {
    condition     = length(var.bucket) >= 3
    error_message = "The name of the bucket must not be empty"
  }
  validation {
    condition     = length(var.bucket) < 63
    error_message = "The name of the bucket must not exceed 63 characters"
  }
  validation {
    condition     = var.bucket == lower(var.bucket)
    error_message = "The name of the bucket must be in lowercase"
  }
}

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error"
  type        = bool
  default     = false
  nullable    = false
}

variable "object_lock_enabled" {
  description = "A boolean that indicates whether this bucket should have Object Lock enabled"
  type        = bool
  default     = false
  nullable    = false
}

variable "tags" {
  description = "A mapping of tags to assign to the bucket"
  type        = map(any)
  default     = {}
  nullable    = true
}

variable "versioning" {
  description = "A mapping of versioning configuration"
  type = object({
    mfa        = optional(string)
    status     = string
    mfa_delete = optional(string)
  })
  default = {
    status = "Enabled"
  }
}

variable "server_side_encryption" {
  description = "A mapping of server side encryption configuration"
  type = object({
    rule = object({
      bucket_key_enabled = optional(bool)
      apply_server_side_encryption_by_default = optional(object({
        sse_algorithm     = string
        kms_master_key_id = optional(string)
      }))
    })
  })
  default = {
    rule = {
      bucket_key_enabled = false
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
}

# variable "transition_default_minimum_object_size" {
#   description = "The minimum object size in bytes to be considered for Intelligent-Tiering transition"
#   type        = string
#   default     = "all_storage_classes_128K"

#   validation {
#     condition     = can(regex("all_storage_classes_128K|varies_by_storage_class", var.transition_default_minimum_object_size))
#     error_message = "The transition default minimum object size must be either all_storage_classes_128K or varies_by_storage_class"
#   }
# }

# variable "lifecycle_rules" {
#   description = "A list of lifecycle rules"
#   type        = list(any)
#   default     = []
# }

variable "intelligent_tiering" {
  description = "A mapping of tags to assign to the bucket"
  type = object({
    status = optional(string)
    filter = optional(object({
      prefix = optional(string)
      tags   = optional(map(string))
    }))
    tiering = map(any)
  })
  default = {
    status = "Enabled"
    tiering = {
      ARCHIVE_ACCESS = {
        days = 125
      }
      DEEP_ARCHIVE_ACCESS = {
        days = 180
      }
    }
  }

  validation {
    condition     = var.intelligent_tiering.status == null || can(regex("Enabled|Disabled", var.intelligent_tiering.status))
    error_message = "The intelligent tiering status must be either Enabled or Disabled"
  }
}
