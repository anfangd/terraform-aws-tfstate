run "test_iam_policy" {
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
    condition     = aws_iam_policy.this.name == "xxx-policy"
    error_message = "The IAM policy must have the correct name"
  }
}
