terraform {
  backend "s3" {
    bucket       = "terraform-infra-metadata-<AWS_ACCOUNT_ID>"
    key          = "terraform-state/ec2/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
