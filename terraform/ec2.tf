# Security Group for EC2 Instance

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-instance-sg"
  description = "Allow HTTP traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance

resource "aws_instance" "ec2_instance" {
  ami                    = var.custom_ami_version
  instance_type          = "t2.micro"
  subnet_id              = var.public_subnets[0] # Use the first public subnet
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true


  # Attach the IAM Instance Profile for SSM
  iam_instance_profile = aws_iam_instance_profile.ec2_ssm.name

  tags = {
    Name = "ec2-instance"
  }
}

# Allow traffic from the DMS Replication Instance to the EC2 instance on port 5432 (PostgreSQL)

resource "aws_security_group_rule" "ec2_allow_dms" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = var.ec2_security_group_id
  source_security_group_id = aws_security_group.dms_sg.id
}
