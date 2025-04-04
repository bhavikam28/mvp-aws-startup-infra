# ======================
# LAUNCH TEMPLATE CONFIG
# ======================
resource "aws_launch_template" "startup_template" {
  image_id      = data.aws_ami.custom_ami.id  
  instance_type = "t2.micro"

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

  # Subnet selection (using your existing data source)
  vpc_zone_identifier = [data.tfe_outputs.network.values.public_subnet[1]]

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

