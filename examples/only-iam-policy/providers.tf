provider "aws" {
  region = "us-west-2"

  default_tags {
    tags = {
      Environment = "Sandbox"
      Owner       = "Tester"
      Project     = "Test"
    }
  }
}
