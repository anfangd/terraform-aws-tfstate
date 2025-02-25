provider "aws" {
  region = "us-west-2"
}

run "test_name" {
  command = plan
  variables {
    name = "xxx"
  }
  assert {
    condition     = var.name == "xxx"
    error_message = "The name of the DynamoDB table must not be empty"
  }
}

run "test_name_error_1" {
  command = plan

  expect_failures = [var.name]
}

run "test_name_error_2" {
  command = plan
  variables {
    name = "x"
  }
  expect_failures = [var.name]
}

run "test_name_error_3" {
  command = plan
  variables {
    name = join("", [for i in range(256) : "x"])
  }
  expect_failures = [var.name]
}

run "test_billing_mode" {
  command = plan
  variables {
    name         = "xxx"
    billing_mode = "PAY_PER_REQUEST"
  }
  assert {
    condition     = var.billing_mode == "PAY_PER_REQUEST"
    error_message = "billing_mode must be PAY_PER_REQUEST or PROVISIONED"
  }
}

run "test_billing_mode_error" {
  command = plan
  variables {
    name         = "xxx"
    billing_mode = "PAY_PER_REQUEST_"
  }
  expect_failures = [var.billing_mode]
}

run "test_tags" {
  command = plan
  variables {
    name = "xxx"
    tags = {
      key1 = "value1"
      key2 = "value2"
    }
  }
  assert {
    condition     = var.tags["key1"] == "value1"
    error_message = "tags must be a map of strings"
  }
}
