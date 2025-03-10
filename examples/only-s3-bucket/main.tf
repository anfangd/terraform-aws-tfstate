module "s3" {
  source = "../../modules/s3-bucket"

  bucket_name = lower("test-bucket-1234567890-2025-02-25T12-34-56Z")
}
