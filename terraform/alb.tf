# Application Load Balancer resource
resource "aws_lb" "startup_alb" {
  name               = "startup-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ec2_sg.id] 
  subnets            = var.public_subnets  
  
  enable_cross_zone_load_balancing = true            # Ensures traffic is evenly distributed across AZs
  enable_deletion_protection       = false           # Good for testing

  tags = {
    Environment = "startup-alb"
  }
}

# Target Group (with proper health checks)
resource "aws_lb_target_group" "alb_tg" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"           # Critical for health checks!
    timeout             = 15            # How long to wait for a response
    healthy_threshold   = 2             # Number of successes before healthy
    unhealthy_threshold = 4             # Number of failures before unhealthy
    matcher            = "200-399"
  }
}

# ALB Listener 
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.startup_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}