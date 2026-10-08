terraform {
  backend "s3" {
    bucket       = "terraform-infra-metadata-08102026"
    key          = "terraform-state/ec2/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
