variable "name" {
  description = "The name of the DynamoDB table"
  type        = string
  nullable    = false
  default     = ""

  validation {
    condition     = length(var.name) >= 3
    error_message = "The name of the DynamoDB table must not be empty"
  }
  validation {
    condition     = length(var.name) < 256
    error_message = "The name of the DynamoDB table must be less than 256 characters"
  }

}

variable "billing_mode" {
  description = "value for billing_mode"
  type        = string
  default     = "PAY_PER_REQUEST"

  validation {
    condition     = var.billing_mode == "PAY_PER_REQUEST" || var.billing_mode == "PROVISIONED"
    error_message = "billing_mode must be PAY_PER_REQUEST or PROVISIONED"
  }

}

variable "tags" {
  description = "value for tags"
  type        = map(string)
  default     = {}

}
