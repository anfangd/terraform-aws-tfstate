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

# --- S3 Bucket ---

variable "enable_force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error"
  type        = bool
  nullable    = false
  default     = false
}

variable "tags" {
  description = "A mapping of tags to assign to the bucket"
  type        = map(any)
  default     = {}
}

# --- Versioning ---

variable "enable_versioning_mfa_delete" {
  description = "A boolean that indicates whether MFA delete is enabled"
  type        = bool
  nullable    = true
  default     = null
}

variable "versioning_mfa" {
  description = "Concatenation of the authentication device's serial number, a space, and the value that is displayed on your authentication device."
  type        = string
  nullable    = true
  default     = null

  validation {
    condition     = (var.versioning_mfa == null && var.enable_versioning_mfa_delete == null) && var.enable_versioning_mfa_delete == true ? can(length(var.versioning_mfa) > 0) : true
    error_message = "The MFA must be specified when the MFA delete is enabled"
  }
}

# --- Object Lock ---
variable "enable_object_lock" {
  description = "A boolean that indicates whether object lock is enabled"
  type        = bool
  nullable    = true
  default     = false
}

variable "object_lock_mode" {
  description = "The Object Lock mode that you want to apply to the bucket. Valid values are COMPLIANCE and GOVERNANCE."
  type        = string
  nullable    = true
  default     = "COMPLIANCE"

  validation {
    condition     = var.object_lock_mode == null || can(regex("COMPLIANCE|GOVERNANCE", var.object_lock_mode))
    error_message = "The object lock mode must be either COMPLIANCE or GOVERNANCE"
  }
}

variable "object_lock_days" {
  description = "Days to retain objects"
  type        = number
  nullable    = true
  default     = 1
}

variable "object_lock_years" {
  description = "Days to retain objects"
  type        = number
  nullable    = true
  default     = null
}

# --- Server Side Encryption ---

variable "sse_algorithm" {
  description = "The server side encryption algorithm. Valid values are AES256, aws:kms and aws:kms:dsse"
  type        = string
  nullable    = false
  default     = "AES256"

  validation {
    condition     = var.sse_algorithm == null || can(regex("AES256|aws:kms|aws:kms:dsse", var.sse_algorithm))
    error_message = "The server side encryption algorithm must be either AES256, aws:kms or aws:kms:dsse"
  }
}

variable "enable_sse_bucket_key" {
  description = "A boolean that indicates whether the bucket key should be enabled"
  type        = bool
  nullable    = true
  default     = false
}

variable "sse_kms_master_key_id" {
  description = "The KMS master key ID"
  type        = string
  nullable    = true
  default     = null

  validation {
    condition = (
      (var.sse_algorithm != "aws:kms" && var.sse_kms_master_key_id == null)
      || (can(regex("aws:kms", var.sse_algorithm)) && var.sse_kms_master_key_id != null && can(length(var.sse_kms_master_key_id) > 0))
    )
    error_message = "The KMS master key ID must be specified when the server side encryption algorithm is aws:kms"
  }
}

# --- Inteligent Tiering ---

variable "enable_inteligent_tiering" {
  description = "A boolean that indicates whether intelligent tiering is enabled"
  type        = bool
  nullable    = false
  default     = true
}

variable "tiering" {
  description = "A mapping of tiering to assign to the bucket"
  type        = map(any)
  nullable    = false
  default = {
    ARCHIVE_ACCESS = {
      days = 125
    }
    DEEP_ARCHIVE_ACCESS = {
      days = 180
    }
  }
}

# --- Logging ---

variable "logging_target_bucket" {
  description = "The name of the bucket where the log files should be stored"
  type        = string
  nullable    = true
  default     = null
}

variable "logging_target_prefix" {
  description = "The prefix to apply to the log files"
  type        = string
  nullable    = true
  default     = null
}
