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
        #----
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

variable "s3" {
  description = "The configuration for the S3 bucket"
  type = object({
    force_destroy       = bool        # A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error
    object_lock_enabled = bool        # A boolean that indicates whether this bucket should have Object Lock enabled
    tags                = map(string) # A mapping of tags to assign to the bucket
    versioning = object({             # A mapping of versioning configuration
      status = string
    })
    server_side_encryption = object({ # A mapping of server side encryption configuration
      rule = object({
        bucket_key_enabled = bool
        apply_server_side_encryption_by_default = object({
          sse_algorithm = string
        })
      })
    })
    intelligent_tiering = object({ # A mapping of tags to assign to the bucket
      status = string
      filter = object({
        prefix = string
      })
      tiering = map(object({
        days = number
      }))
    })
  })
  default = {
    force_destroy       = false
    object_lock_enabled = false
    tags                = {}
    versioning = {
      status = "Enabled"
    }
    server_side_encryption = {
      rule = {
        bucket_key_enabled = false
        apply_server_side_encryption_by_default = {
          sse_algorithm = "AES256"
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
}

variable "dynamodb" {
  description = "The configuration for the DynamoDB table"
  type = object({
    table_name = optional(string)
    tags       = optional(map(string))
  })
  default = {
    table_name = ""
    tags       = {}
  }
}

variable "iam" {
  description = "The configuration for the IAM policy"
  type = object({
    policy_name = string
  })
  default = {
    policy_name = ""
  }
}
