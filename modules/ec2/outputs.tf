output "instance_id" {
  value = aws_instance.main.id
}

output "public_ip" {
  value = aws_instance.main.public_ip
}

output "private_ip" {
  value = aws_instance.main.private_ip
}

output "public_dns" {
  value = aws_instance.main.public_dns
}

output "ami_id" {
  value = aws_instance.main.ami
}

output "instance_type" {
  value = aws_instance.main.instance_type
}

output "security_group_id" {
  value = var.security_group_id
}

output "subnet_id" {
  value = aws_instance.main.subnet_id
}

output "key_name" {
  value = aws_instance.main.key_name
}
