# DMS Replication Instance

resource "aws_dms_replication_instance" "dms_replication_instance" {
  replication_instance_id      = "dms-replication-instance"
  replication_instance_class   = "dms.t2.micro" # Free Tier eligible
  allocated_storage            = 20 # Minimum storage for Free Tier
  engine_version               = "3.4.7" # Latest DMS version
  publicly_accessible          = false
  multi_az                    = false # Single-AZ for Free Tier
  vpc_security_group_ids      = [aws_security_group.dms_sg.id]
  replication_subnet_group_id  = aws_dms_replication_subnet_group.dms_subnet_group.id

  tags = {
    Name = "dms-replication-instance"
  }
}

# Defined subnet in the specified VPC to create a replication instance

resource "aws_dms_replication_subnet_group" "dms_subnet_group" {
  replication_subnet_group_id = "dms-subnet-group"
  replication_subnet_group_description = "DMS subnet group"
  subnet_ids = var.private_subnets  
}

# Security Group for DMS Replication Instance

resource "aws_security_group" "dms_sg" {
  name        = "dms-sg"
  description = "Allow outbound traffic for DMS Replication Instance"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Source Endpoint (EC2 Database)

resource "aws_dms_endpoint" "source_endpoint" {
  endpoint_id   = "source-endpoint"
  endpoint_type = "source"
  engine_name   = "postgres"
  server_name   = var.ec2_database_host # Replace with the EC2 database host
  port          = 5432
  username      = var.db_username
  password      = var.db_password
  database_name = var.ec2_database_name # Replace with the EC2 database name
}


# Target Endpoint (RDS Database)

resource "aws_dms_endpoint" "target_endpoint" {
  endpoint_id   = "target-endpoint"
  endpoint_type = "target"
  engine_name   = "postgres"
  server_name   = aws_db_instance.mvp_db.endpoint
  port          = 5432
  username      = var.db_username
  password      = var.db_password
  database_name = "mvp"
}

# DMS Replication Task

resource "aws_dms_replication_task" "dms_replication_task" {
  replication_task_id      = "dms-replication-task"
  migration_type           = "full-load" # Full-load replication
  replication_instance_arn = aws_dms_replication_instance.dms_replication_instance.replication_instance_arn
  source_endpoint_arn      = aws_dms_endpoint.source_endpoint.endpoint_arn
  target_endpoint_arn      = aws_dms_endpoint.target_endpoint.endpoint_arn
  table_mappings           = <<EOF
  {
    "rules": [
      {
        "rule-type": "selection",
        "rule-id": "1",
        "rule-name": "1",
        "object-locator": {
          "schema-name": "public",
          "table-name": "%"
        },
        "rule-action": "include"
      }
    ]
  }
  EOF
}