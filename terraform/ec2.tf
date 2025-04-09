# Security Group for EC2 Instance (used by both ALB and EC2)
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-instance-sg"
  description = "Allow HTTP from ALB"
  vpc_id      = var.vpc_id

  # Allow public HTTP to ALB (since ALB uses this SG)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Public access to ALB
  }

  # Allow internal ALB→EC2 traffic 
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]  
  }

  # Allow all outbound traffic 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

    # Allow PostgreSQL traffic from the DMS replication instance
#  ingress {
 #   from_port       = 5432
 #   to_port         = 5432
 #   protocol        = "tcp"
 #   security_groups = [aws_security_group.dms_sg.id]
 # }
  
  
  lifecycle {
    prevent_destroy = true # Block ALL deletion attempts
  }

  tags = {
    Name = "ec2-instance-sg"
  }
}



# EC2 Instance
# resource "aws_instance" "ec2_instance" {
#  ami                    = var.custom_ami_version
# instance_type          = "t2.micro"
#  subnet_id              = var.public_subnets[0] # Use the first public subnet
# vpc_security_group_ids = [aws_security_group.ec2_sg.id]
# associate_public_ip_address = true

  # Attach the IAM Instance Profile for SSM
#  iam_instance_profile = aws_iam_instance_profile.ec2_ssm.name

#  tags = {
#    Name = "ec2-instance"
#  }
# }
