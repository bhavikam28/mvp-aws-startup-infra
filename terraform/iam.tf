# ======================
# IAM ROLE FOR EC2 INSTANCE
# ======================
# Creates an IAM role that allows EC2 instances to assume other AWS service permissions
resource "aws_iam_role" "ec2_ssm" {
  name = "ec2_ssm_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# ======================
# SSM CORE PERMISSIONS
# ======================
# Attaches the managed AWS policy that enables Systems Manager session manager access
# This allows SSH-free connection to the EC2 instance via AWS console
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ======================
# IAM INSTANCE PROFILE
# ======================
# Creates a container for the IAM role that can be attached to EC2 instances
resource "aws_iam_instance_profile" "ec2_ssm" {
  name = "ec2_ssm_profile"
  role = aws_iam_role.ec2_ssm.name
}
