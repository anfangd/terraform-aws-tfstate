provider "aws" {
  region = "us-west-2"
}

run "test_policy_name" {
  command = plan
  variables {
    policy_name = "xxx"
    s3 = [{
      bucket_name = "xxx"
      key_prefix  = "yyy"
    }]
    dynamodb = [{
      table_name     = "xxx"
      region         = "us-west-2"
      aws_account_id = "123456789012"
    }]
  }
  assert {
    condition     = var.policy_name == "xxx"
    error_message = "The policy name must not be empty"
  }
  assert {
    condition     = var.s3[0].bucket_name == "xxx"
    error_message = "The bucket name must not be empty"
  }
  assert {
    condition     = var.s3[0].key_prefix == "yyy"
    error_message = "The key prefix must not be empty"
  }
}

run "test_policy_name_error_1" {
  command = plan
  # variables {
  #   policy_name = "xx"
  #   s3 = [{
  #     bucket_name = "xxx"
  #   }]
  #   dynamodb = [{
  #     table_name     = "xxx"
  #     region         = "us-west-2"
  #     aws_account_id = "123456789012"
  #   }]
  # }
  expect_failures = [var.policy_name, var.s3.bucket_name]
}

run "test_policy_name_error_2" {
  command = plan
  variables {
    policy_name = "xx"
    s3 = [{
      bucket_name = "xx"
    }]
    # dynamodb = [{
    #   table_name     = "xxx"
    #   region         = "us-west-2"
    #   aws_account_id = "123456789012"
    # }]
  }
  expect_failures = [var.policy_name, var.s3.bucket_name]
}
