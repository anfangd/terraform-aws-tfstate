provider "aws" {
  region = "us-west-2"
}

run "test_variables" {
  command = plan
  variables {
    env     = "dev"
    product = "test"
    # usage   = ""
    region  = "us-west-2"
    suffix  = "000"
    tfstate_lock_type = "None"
    # s3 = {}
    # dynamodb = {}
    # iam = { policy_name = "" }
  }
  assert {
    condition     = var.env == "test"
    error_message = "The environment must be test"
  }
  assert {
    condition     = var.product == "test"
    error_message = "The product name must be test"
  }
  assert {
    condition     = var.usage == "test"
    error_message = "The usage name must be test"
  }
  assert {
    condition     = var.region == "us-west-2"
    error_message = "The region must be us-west-2"
  }
}
