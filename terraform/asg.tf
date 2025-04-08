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
    security_groups             = [aws_security_group.ec2_sg.id]  # Updated SG
  }
}

# ========================
# AUTO SCALING GROUP CONFIG
# ========================
resource "aws_autoscaling_group" "startup_asg" {
  min_size         = 1  # Required minimum
  max_size         = 5  # Required maximum
  desired_capacity = 1  # Initial capacity
  
  # Explicit dependency declaration
  depends_on = [aws_security_group.ec2_sg]

  # Subnet selection 
  vpc_zone_identifier = var.public_subnets 

  # Connect to ALB Target Group
  target_group_arns = [aws_lb_target_group.alb_tg.arn]  # Reference from alb.tf
  
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

# ========================
# AUTO SCALING POLICY (Target Tracking)
# ========================
resource "aws_autoscaling_policy" "cpu_target_tracking" {
  name                   = "cpu-target-tracking"
  policy_type            = "TargetTrackingScaling"
  estimated_instance_warmup = 60
  autoscaling_group_name = aws_autoscaling_group.startup_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60.0
  }
}