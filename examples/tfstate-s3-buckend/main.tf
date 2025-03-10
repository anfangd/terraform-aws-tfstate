module "tfstate" {
  source = "../../"

  env     = "test"
  product = "platform"
  usage   = "tfstate"
  region  = "us-west-2"
  suffix  = "1234"

  tfstate_lock_type = "DynamoDB"

  # s3 = {
  # }

  dynamodb = {
    table_name = "test-platform-tfstate-uw2"
    tags = {
      Name = "test-platform-tfstate-uw2"
    }
  }
}
