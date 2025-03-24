# Security Group for EC2 Instance
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-instance-sg"
  description = "Allow HTTP traffic"
  vpc_id      = var.vpc_id

  # Allow HTTP traffic (required by assignment)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP access"
  }

  # Allow all outbound traffic (required by assignment)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "ec2-instance-sg"
  }
}


# EC2 Instance
resource "aws_instance" "ec2_instance" {
  ami                    = data.aws_ami.custom_ami.id  # Using AMI data source
  instance_type          = "t2.micro"                 # Required by assignment
  subnet_id              = var.public_subnets[0]       # Required: using first public subnet
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true                  # Required by assignment

  tags = {
    Name = "ec2-instance-${var.custom_ami_version}"   # Include AMI version in name
  }
}