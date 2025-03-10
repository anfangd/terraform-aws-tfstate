output "iam" {
  description = "output of iam policy"
  value = {
    policy = module.iam
  }
}
