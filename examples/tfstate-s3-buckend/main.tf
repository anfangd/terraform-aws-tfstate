module "tfstate" {
  source = "../../"

  env     = "test"
  product = "platform"
  usage   = "tfstate"
  region  = "us-west-2"
  suffix  = "1234"

  tfstate_lock_type = "DynamoDB"

  enable_force_destroy = false
  enable_object_lock   = false
  sse_algorithm        = "AES256"
  # enable_sse_bucket_key =
  # kms_master_key_id =
  # enable_inteligent_tiering =
  # tiering_level =
  # logging_target_bucket =
  # logging_target_prefix =

  dynamodb_table_name = "terraform-state-lock"
}
