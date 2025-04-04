# ======================
# LAUNCH TEMPLATE CONFIG
# ======================
resource "aws_launch_template" "startup_template" {
  image_id      = var.custom_ami_version
  instance_type = "t2.micro"

   # SSM access via IAM instance profile
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_ssm.name
  }

  # Required detailed monitoring
  monitoring {
    enabled = true
  }

  # Network config with public IP and your security group
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.ec2_sg.id]
  }
}

# ========================
# AUTO SCALING GROUP CONFIG
# ========================
resource "aws_autoscaling_group" "startup_asg" {
  min_size         = 1  # Required minimum
  max_size         = 5  # Required maximum
  desired_capacity = 1  # Initial capacity

  # Subnet selection 
  vpc_zone_identifier = var.public_subnets 

  launch_template {
    id      = aws_launch_template.startup_template.id
    version = "$Latest"
  }

 # This ensures all launched instances get the tag
  tag {
    key                 = "Name"
    value               = "ec2-asg-instance"
    propagate_at_launch = true 
  }
}

