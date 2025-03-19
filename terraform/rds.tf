# RDS Parameter Group
resource "aws_db_parameter_group" "mvp_db_parameter_group" {
  name   = "mvp-db-parameter-group"
  family = "postgres16" # Parameter group family for PostgreSQL 16.3

  parameter {
    name  = "rds.force_ssl"
    value = "0" # Disable SSL enforcement
  }
}

# RDS Subnet Group
resource "aws_db_subnet_group" "mvp_db_subnet_group" {
  name       = "mvp-db-subnet-group"
  subnet_ids = var.private_subnets 
}

# RDS Security Group
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow inbound PostgreSQL traffic from EC2 instance"
  vpc_id      = var.vpc_id 

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [var.ec2_security_group_id] # Allow traffic from the EC2 instance
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS PostgreSQL Instance
resource "aws_db_instance" "mvp_db" {
  identifier           = "mvp-db"
  engine               = "postgres"
  engine_version       = "16.3"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20 # Minimum storage for Free Tier
  storage_type         = "gp2"
  db_name              = "mvp"
  username             = var.db_username
  password             = var.db_password
  publicly_accessible  = false
  skip_final_snapshot  = true # Set to false in production to avoid accidental deletion
  multi_az             = false # Single-AZ for Free Tier
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.mvp_db_subnet_group.name
  parameter_group_name = aws_db_parameter_group.mvp_db_parameter_group.name
}


# Allow traffic from the DMS Replication Instance to the RDS instance on port 5432 (PostgreSQL)

resource "aws_security_group_rule" "rds_allow_dms" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = aws_security_group.dms_sg.id
}
