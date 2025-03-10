output "s3" {
  description = "output of s3 bucket"
  value = {
    bucket                 = module.s3.bucket
    versioning             = module.s3.versioning
    server_side_encryption = module.s3.server_side_encryption
    public_access_block    = module.s3.public_access_block
    ownership_controls     = module.s3.ownership_controls
    intelligent_tiering    = module.s3.intelligent_tiering
    logging                = module.s3.logging
  }
}
