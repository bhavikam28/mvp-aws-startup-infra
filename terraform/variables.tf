variable "custom_ami_version" {
  description = "The version of the custom AMI to use"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of IDs of the public subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of IDs of the private subnets"
  type        = list(string)
}


variable "db_username" {
  type      = string
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}


variable "ec2_security_group_id" {
  type        = string
  description = "The Security Group ID of the EC2 instance"
}