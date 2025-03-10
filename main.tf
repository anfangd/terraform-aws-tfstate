locals {
  terraform = {
    module = {
      name    = "tfstate-s3-backend"
      version = "v0.0.1"
    }
  }
  region_code = {
    "us-east-1"      = "ue1",
    "us-east-2"      = "ue2",
    "us-west-1"      = "uw1",
    "us-west-2"      = "uw2",
    "ap-south-1"     = "as1",
    "ap-northeast-1" = "an1",
    "ap-northeast-2" = "an2",
    "ap-northeast-3" = "an3",
    "ap-southeast-1" = "as1",
    "ap-southeast-2" = "as2",
    "ap-southeast-3" = "as3",
    "ca-central-1"   = "cc1",
    "eu-central-1"   = "ec1",
    "eu-west-1"      = "ew1",
    "eu-west-2"      = "ew2",
    "eu-west-3"      = "ew3",
    "eu-north-1"     = "en1",
    "sa-east-1"      = "se1"
  }
  tags = {
    TfModuleName    = local.terraform.module.name
    TfModuleVersion = local.terraform.module.version
  }
  s3 = {
    bucket_name = "${var.env}-${var.product}-${var.usage}-${local.region_code[var.region]}-${var.suffix}"
    tags        = merge(var.s3.tags, local.tags)
  }
  dynamodb = {
    table_name = try(var.dynamodb.table_name, "") != "" ? var.dynamodb.table_name : "${var.env}-${var.product}-${var.usage}-${local.region_code[var.region]}"
    tags       = merge(var.dynamodb.tags, local.tags)
  }
  iam_policy = {
    policy_name = try(var.iam.policy_name, "") != "" ? var.iam.policy_name : "${var.env}-${var.product}-${var.usage}-${var.suffix}"
  }
}

# --- Amazon S3 ---

module "s3" {
  source = "./modules/s3-bucket"

  bucket_name            = local.s3.bucket_name
  force_destroy          = var.s3.force_destroy
  object_lock_enabled    = var.s3.object_lock_enabled
  tags                   = local.s3.tags
  versioning             = var.s3.versioning
  server_side_encryption = var.s3.server_side_encryption
  intelligent_tiering    = var.s3.intelligent_tiering
}

# --- Amazon DynamoDB ---

resource "aws_dynamodb_table" "this" {
  count = var.tfstate_lock_type == "DynamoDB" ? 1 : 0

  name         = local.dynamodb.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = local.dynamodb.tags

  lifecycle {
    precondition {
      condition     = length(local.dynamodb.table_name) >= 3
      error_message = "The name of the DynamoDB table must not be empty"
    }
    precondition {
      condition     = length(local.dynamodb.table_name) < 256
      error_message = "The name of the DynamoDB table must be less than 256 characters"
    }
  }
}

# --- IAM Policy ---

locals {
  dynamodb_tables = var.tfstate_lock_type == "DynamoDB" ? [{
    table_arn = try(aws_dynamodb_table.this[0].arn, "")
  }] : []
}

module "iam_policy" {
  source = "./modules/iam-policy"

  policy_name = local.iam_policy.policy_name
  s3 = [{
    bucket_name = local.s3.bucket_name
    key_prefix  = ""
  }]
  dynamodb = local.dynamodb_tables
}
