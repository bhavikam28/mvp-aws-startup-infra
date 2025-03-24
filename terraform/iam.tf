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




# ======================
# S3 BUCKET ACCESS
# ======================
# Grants the EC2 instance permissions to:
# - Upload images (PutObject)
# - Retrieve images (GetObject)
# - Delete images (DeleteObject) 
# - List bucket contents (ListBucket)
resource "aws_iam_role_policy" "ec2_s3_access" {
  name = "ec2-s3-access"
  role = aws_iam_role.ec2_ssm.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Effect   = "Allow",
        Resource = [
          aws_s3_bucket.startup_image_bucket.arn,
          "${aws_s3_bucket.startup_image_bucket.arn}/*"
        ]
      }
    ]
  })
}

# ======================
# SSM PARAMETER STORE ACCESS
# ======================
# Allows the EC2 instance to read configuration parameters from AWS Systems Manager
# Used for storing secrets or configuration values securely
resource "aws_iam_role_policy" "ssm_parameter_access" {
  name = "ssm-parameter-access"
  role = aws_iam_role.ec2_ssm.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action   = ["ssm:GetParameter", "ssm:GetParameters"],
      Effect   = "Allow",
      Resource = "arn:aws:ssm:us-east-1:${data.aws_caller_identity.current.account_id}:parameter/your-app/*"
    }]
  })
}

