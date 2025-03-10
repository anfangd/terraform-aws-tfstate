variable "policy_name" {
  description = "The name of the IAM policy"
  type        = string
  nullable    = false
  default     = ""

  validation {
    condition     = length(var.policy_name) >= 3
    error_message = "The policy name must not be empty"
  }
}

variable "s3" {
  description = "List of S3 bucket to allow access"
  type = list(object({
    bucket_name = string           # The bucket name to allow access
    key_prefix  = optional(string) # The key prefix to allow access
  }))
  default = [{
    bucket_name = ""
  }]

  validation {
    condition     = alltrue([for v in var.s3 : length(v.bucket_name) >= 3])
    error_message = "Each S3 bucket name must be at least 3 characters long"
  }
}

variable "dynamodb" {
  description = "The DynamoDB table to allow access"
  type = list(object({
    table_arn = string # The ARN of the DynamoDB table to allow access
  }))
  default = []

  validation {
    condition = var.dynamodb == null || length(var.dynamodb) == 0 || alltrue([
      # Check if the table ARN is a valid ARN
      for d in var.dynamodb : length(regexall("^arn:aws:dynamodb:[a-z0-9-]+:[0-9]{12}:table/[a-zA-Z0-9_.-]+$", d.table_arn)) > 0
    ])
    error_message = "The AWS account ID must be a 12-digit number"
  }
}
