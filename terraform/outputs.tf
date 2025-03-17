output "vpc_id" {
  description = "The ID of the VPC"
  value       = var.vpc_id
}

output "public_subnets" {
  description = "List of IDs of the public subnets"
  value       = var.public_subnets
}

output "private_subnets" {
  description = "List of IDs of the private subnets"
  value       = var.private_subnets
}

output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.ec2_instance.public_ip
}

output "ec2_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.ec2_instance.public_ip
}

output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.ec2_instance.id
}