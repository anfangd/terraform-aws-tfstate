module "iam" {
  source = "../../modules/iam-policy"

  policy_name = "test-platform-tfstate-uw2"
  s3 = [
    {
      bucket_name = "test-platform-tfstate-uw2-1234"
      key_prefix  = "platform/tfstate/1234/"
    },
    {
      bucket_name = "test-platform-tfstate-uw2-5678"
      key_prefix  = "platform/tfstate/5678/"
    }
  ]
  # dynamodb = [
  #   {
  #     table_arn     = ""
  #   },
  # ]
}
