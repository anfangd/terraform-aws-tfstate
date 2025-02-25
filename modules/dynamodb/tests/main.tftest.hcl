run "apply_dynamodb_table" {
  variables {
    name = "test_table"
    tags = {
      ManagedBy = "Terraform"
      Usage     = "Test"
    }
  }

  assert {
    condition     = aws_dynamodb_table.this.name == "test_table"
    error_message = "The DynamoDB table must have the correct name"
  }
  assert {
    condition     = aws_dynamodb_table.this.hash_key == "LockID"
    error_message = "The DynamoDB table must have the correct hash key"
  }
}
