output "instance_id" {
  value = module.ec2.instance_id
}

output "public_ip" {
  value = module.ec2.public_ip
}

output "private_ip" {
  value = module.ec2.private_ip
}

output "public_dns" {
  value = module.ec2.public_dns
}

output "ssh_command" {
  value = "ssh -i ec2-key.pem ec2-user@${module.ec2.public_ip}"
}

output "metadata_bucket" {
  value = var.metadata_bucket
}

output "metadata_object_key" {
  value = "ec2/${module.ec2.instance_id}.json"
}

output "keypair_path" {
  value = "./ec2-key.pem"
}
