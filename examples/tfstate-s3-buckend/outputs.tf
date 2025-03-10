output "tfstate" {
  description = "output of tfstate module"
  value = {
    dynamodb = module.tfstate.dynamodb
    s3       = module.tfstate.s3
    iam      = module.tfstate.iam
  }
}
