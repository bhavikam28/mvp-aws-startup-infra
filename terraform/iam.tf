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
# CUSTOMER-MANAGED POLICIES
# ======================

# 1. S3 Access Policy
resource "aws_iam_policy" "s3_access" {
  name        = "EC2S3AccessPolicy"
  description = "Grants S3 access to the startup image bucket"
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

# 2. SSM Parameter Access Policy
resource "aws_iam_policy" "ssm_parameter_access" {
  name        = "EC2SSMParameterAccessPolicy"
  description = "Allows read access to SSM Parameter Store"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action   = ["ssm:GetParameter", "ssm:GetParameters"],
      Effect   = "Allow",
      Resource = "arn:aws:ssm:us-east-1:${data.aws_caller_identity.current.account_id}:parameter/your-app/*"
    }]
  })
}

# 3. CloudFront Access Policy
resource "aws_iam_policy" "cloudfront_access" {
  name        = "EC2CloudFrontAccessPolicy"
  description = "Grants CloudFront management permissions"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "cloudfront:GetDistribution",
          "cloudfront:ListDistributions",
          "cloudfront:CreateInvalidation"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

# ======================
# POLICY ATTACHMENTS 
# ======================

resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = aws_iam_policy.s3_access.arn
}

resource "aws_iam_role_policy_attachment" "ssm_parameter_access" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = aws_iam_policy.ssm_parameter_access.arn
}

resource "aws_iam_role_policy_attachment" "cloudfront_access" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = aws_iam_policy.cloudfront_access.arn
}