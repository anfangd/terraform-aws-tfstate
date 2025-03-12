# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables
# ---------------------------------------------------------------------------------------------------------------------

# This module has no environment variables

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These variables are expected to be passed in by the operator
# ---------------------------------------------------------------------------------------------------------------------

variable "env" {
  description = "The environment to create resources in"
  type        = string
  nullable    = false
  # default     = "dev"

  validation {
    condition = contains(
      [
        # List of valid environments
        # cf. [Deployment environment - Wikipedia](https://en.wikipedia.org/wiki/Deployment_environment#Development)
        # --- SDLC ---
        "dev",     # Development
        "trunk",   # Trunk
        "integ",   # Integration
        "qc",      # Quality Control
        "iacep",   # Internal Acceptance
        "test",    # Test
        "stag",    # Staging
        "preprod", # Pre-Production
        "eacep",   # External Acceptance
        "demo",    # Demo
        "prod",    # Production
        "live",    # Live
        # --- Non SDLC ---
        "sec",     # Security
        "sandbox", # Sandbox
        "deploy",  # Deployment
        "platfm",  # Platform
        "share",   # Sharing
      ],
      var.env
    )
    error_message = "The environment must be a valid environment"
  }
}

variable "product" {
  description = "The product to create resources for"
  type        = string
  nullable    = false
  # default     = ""

  validation {
    condition     = length(var.product) >= 3
    error_message = "The product name must not be empty"
  }
}

variable "usage" {
  description = "The usage to create resources for"
  type        = string
  nullable    = false
  default     = "tfstate"

  validation {
    condition     = length(var.usage) >= 3
    error_message = "The usage name must not be empty"
  }
}

variable "region" {
  description = "The region to create resources in"
  type        = string
  nullable    = false
  # default     = "us-west-2"

  validation {
    condition = contains(
      [
        "us-east-1", "us-east-2", "us-west-1", "us-west-2",
        "ap-south-1", "ap-northeast-1", "ap-northeast-2", "ap-northeast-3",
        "ap-southeast-1", "ap-southeast-2", "ap-southeast-3",
        "ca-central-1", "eu-central-1", "eu-west-1", "eu-west-2", "eu-west-3",
        "eu-north-1", "sa-east-1"
      ],
      var.region
    )
    error_message = "The region must be a valid AWS region"
  }
}

variable "suffix" {
  description = "The suffix to append to S3 Bucket"
  type        = string
  # default     = null

  validation {
    condition     = length(var.suffix) >= 3
    error_message = "The suffix name must not be empty"
  }
  validation {
    condition     = length(var.suffix) < 7
    error_message = "The suffix name must not exceed 7 characters"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defaults and may be overridden
# ---------------------------------------------------------------------------------------------------------------------

variable "tfstate_lock_type" {
  description = "The type of lock to use for the state file (None, DynamoDB, S3)"
  type        = string
  nullable    = false
  default     = "None"

  validation {
    condition     = can(regex("None|DynamoDB|S3", var.tfstate_lock_type))
    error_message = "The state lock type must be either None, DynamoDB or S3"
  }
}

# --- S3 Bucket ---

variable "tags" {
  description = "The tags to assign to the resources"
  type        = map(string)
  nullable    = true
  default     = {}
}

variable "enable_force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error"
  type        = bool
  nullable    = false
  default     = false
}

variable "enable_object_lock" {
  description = "A boolean that indicates whether object lock is enabled"
  type        = bool
  nullable    = false
  default     = false
}

# --- S3 Bucket Server Side Encryption ---

variable "sse_algorithm" {
  description = "The server side encryption algorithm"
  type        = string
  nullable    = false
  default     = "AES256"

  validation {
    condition     = can(regex("AES256|aws:kms|aws:kms:dsse", var.sse_algorithm))
    error_message = "The server side encryption algorithm must be either AES256, aws:kms or aws:kms:dsse"
  }
}

variable "enable_sse_bucket_key" {
  description = "A boolean that indicates whether server side encryption is enabled"
  type        = bool
  nullable    = false
  default     = false
}

variable "kms_master_key_id" {
  description = "The KMS master key ID"
  type        = string
  nullable    = true
  default     = null

  validation {
    condition     = can(regex("aws:kms|aws:kms:dsse", var.sse_algorithm)) ? var.kms_master_key_id != null : true
    error_message = "The KMS master key ID must be specified when the server side encryption algorithm is aws:kms or aws:kms:dsse"
  }
}

# --- S3 Bucket Inteligent Tiering ---

variable "enable_inteligent_tiering" {
  description = "A boolean that indicates whether intelligent tiering is enabled"
  type        = bool
  nullable    = false
  default     = true
}

variable "tiering_level" {
  description = "The tiering level"
  type        = string
  nullable    = false
  default     = "Basic"

  validation {
    condition     = can(regex("Basic|Long", var.tiering_level))
    error_message = "The tiering level must be either Basic or Long"
  }
}

# --- S3 Bucket Access Logging ---

variable "logging_target_bucket" {
  description = "The target bucket for access logs"
  type        = string
  nullable    = true
  default     = null
}

variable "logging_target_prefix" {
  description = "The target prefix for access logs"
  type        = string
  nullable    = true
  default     = null
}

# --- DynamoDB Table ---

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table to lock the state file"
  type        = string
  nullable    = true
  default     = null
}

# --- IAM Policy ---

variable "iam_policy_name" {
  description = "The name of the IAM policy which grants access to the S3 bucket"
  type        = string
  nullable    = true
  default     = null
}
