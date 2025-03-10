# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables
# ---------------------------------------------------------------------------------------------------------------------

# This module has no environment variables

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These variables are expected to be passed in by the operator
# ---------------------------------------------------------------------------------------------------------------------

variable "bucket_name" {
  description = "The name of the bucket"
  type        = string
  nullable    = false
  # default     = ""

  validation {
    condition     = length(var.bucket_name) >= 3
    error_message = "The name of the bucket must not be empty"
  }
  validation {
    condition     = length(var.bucket_name) < 63
    error_message = "The name of the bucket must not exceed 63 characters"
  }
  validation {
    condition     = var.bucket_name == lower(var.bucket_name)
    error_message = "The name of the bucket must be in lowercase"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defaults and may be overridden
# ---------------------------------------------------------------------------------------------------------------------

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error"
  type        = bool
  nullable    = false
  default     = false
}

variable "object_lock_enabled" {
  description = "A boolean that indicates whether this bucket should have Object Lock enabled"
  type        = bool
  nullable    = false
  default     = false
}

variable "tags" {
  description = "A mapping of tags to assign to the bucket"
  type        = map(any)
  default     = {}
}

variable "versioning" {
  description = "A mapping of versioning configuration"
  type = object({
    mfa        = optional(string)
    status     = string
    mfa_delete = optional(string)
  })
  nullable = false
  default = {
    status = "Enabled"
  }

  validation {
    condition     = (var.versioning.mfa == null && var.versioning.mfa_delete == null) && var.versioning.mfa_delete == "Enabled" ? can(length(var.versioning.mfa) > 0) : true
    error_message = "The MFA must be specified when the MFA delete is enabled"
  }
  validation {
    condition     = can(regex("Enabled|Suspended|Disabled", try(var.versioning.status, "")))
    error_message = "The versioning status must be either Enabled, Suspended or Disabled"
  }
  validation {
    condition     = var.versioning.mfa_delete == null || can(regex("Enabled|Disa bled", var.versioning.mfa_delete, ""))
    error_message = "The versioning MFA delete must be either Enabled or Disabled"
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

variable "logging" {
  description = "A mapping of logging configuration"
  type = object({
    target_bucket = string
    target_prefix = optional(string)
  })
  default = {
    target_bucket = ""
  }
}
