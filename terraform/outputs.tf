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

output "rds_endpoint" {
  value = aws_db_instance.mvp_db.endpoint
}

output "rds_username" {
  value = aws_db_instance.mvp_db.username
  sensitive = true # Mark this output as sensitive
}

output "dms_replication_instance_arn" {
  value = aws_dms_replication_instance.dms_replication_instance.replication_instance_arn
}

output "source_endpoint_arn" {
  value = aws_dms_endpoint.source_endpoint.endpoint_arn
}

output "target_endpoint_arn" {
  value = aws_dms_endpoint.target_endpoint.endpoint_arn
}

output "dms_replication_task_arn" {
  value = aws_dms_replication_task.dms_replication_task.replication_task_arn
}