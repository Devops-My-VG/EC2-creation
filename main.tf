data "aws_ssm_parameter" "metadata_bucket" {
  name = var.ssm_bucket_param
}

locals {
  metadata_bucket = try(data.aws_ssm_parameter.metadata_bucket.value, var.metadata_bucket)
}

module "vpc" {
  source            = "./modules/vpc"
  vpc_cidr          = var.vpc_cidr
  subnet_cidr       = var.subnet_cidr
  availability_zone = var.availability_zone
  project_name      = var.project_name
}

module "security_group" {
  source       = "./modules/security-group"
  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
}

module "keypair" {
  source       = "./modules/keypair"
  project_name = var.project_name
}

module "ec2" {
  source            = "./modules/ec2"
  instance_type     = var.instance_type
  subnet_id         = module.vpc.subnet_id
  security_group_id = module.security_group.security_group_id
  key_name          = module.keypair.key_name
  project_name      = var.project_name
}

resource "aws_s3_object" "ec2_details" {
  bucket       = local.metadata_bucket
  key          = "ec2/${module.ec2.instance_id}.json"
  content_type = "application/json"
  content = jsonencode({
    instance_id       = module.ec2.instance_id
    public_ip         = module.ec2.public_ip
    private_ip        = module.ec2.private_ip
    public_dns        = module.ec2.public_dns
    key_name          = module.ec2.key_name
    security_group_id = module.ec2.security_group_id
    subnet_id         = module.ec2.subnet_id
    ami_id            = module.ec2.ami_id
    instance_type     = module.ec2.instance_type
    ssh_command       = "ssh -i ec2-key.pem ec2-user@${module.ec2.public_ip}"
    created_at        = timestamp()
  })
}

resource "aws_s3_object" "latest" {
  bucket       = local.metadata_bucket
  key          = "ec2/latest.json"
  content_type = "application/json"
  content = jsonencode({
    instance_id = module.ec2.instance_id,
    public_ip   = module.ec2.public_ip
  })
}
