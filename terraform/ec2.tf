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

  tags = {
    Name = "ec2-instance"
  }
}