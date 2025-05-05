# To fetch existing log group
data "aws_cloudwatch_log_group" "startup" {
    name = "/startup/app"
}


# CloudWatch Log Metric Filter resource
resource "aws_cloudwatch_log_metric_filter" "upload_count" {
  name           = "UploadCountFilter"
  pattern        = "\"PUT /media/user_images/\""
  log_group_name = data.aws_cloudwatch_log_group.startup.name

  metric_transformation {
    name      = "UploadCount"
    namespace = "StartupApp"
    value     = "1"
    unit      = "Count"
  }
}

# SNS Topic for Alarm Notifications
resource "aws_sns_topic" "alarm_notification" {
  name = "AlarmNotificationTopic"
}


########################################################################
# CloudWatch Alarms
########################################################################

# EC2 CPU and Memory Alarms

# These alarms will trigger when CPU or Memory usage exceeds 70% for 2 consecutive periods of 120 seconds
# and will send notifications to the SNS topic created above.

resource "aws_cloudwatch_metric_alarm" "startup_ec2_cpu" {
  
  alarm_name          = "EC2HighCPUAlarm"
  alarm_description   = "Alarm when CPU exceeds 70%"                
  comparison_operator = "GreaterThanThreshold"        
  evaluation_periods   = "2"      
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2" 
  period              = "120"  
  statistic           = "Average"
  threshold           = "70"  # CPU threshold
  alarm_actions       = [aws_sns_topic.alarm_notification.arn] # SNS topic ARN for alarm notifications
  ok_actions          = [aws_sns_topic.alarm_notification.arn] # SNS topic ARN for OK notifications
  dimensions          = {
    AutoScalingGroupName = aws_autoscaling_group.startup_asg.name
    }     
 }

resource "aws_cloudwatch_metric_alarm" "startup_ec2_memory" {
  
  alarm_name          = "EC2HighMemoryAlarm"
  alarm_description   = "Alarm when Memory exceeds 70%"                
  comparison_operator = "GreaterThanThreshold"        
  evaluation_periods   = "2"
  metric_name         = "MEM_USAGE_PERCENT"
  namespace           = "CWAgent" 
  period              = "120"  
  statistic           = "Average"
  threshold           = "70"  # Memory threshold
  alarm_actions       = [aws_sns_topic.alarm_notification.arn] # SNS topic ARN for alarm notifications
  ok_actions          = [aws_sns_topic.alarm_notification.arn] # SNS topic ARN for OK notifications
  dimensions          = {
    AutoScalingGroupName = aws_autoscaling_group.startup_asg.name
    }
}

# RDS CPU Alarm
resource "aws_cloudwatch_metric_alarm" "startup_rds_cpu" {
  
  alarm_name          = "RDSHighCPUAlarm"
  alarm_description   = "Alarm when RDS CPU exceeds 70%"                
  comparison_operator = "GreaterThanThreshold"        
  evaluation_periods   = "2"      
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS" 
  period              = "120"  
  statistic           = "Average"
  threshold           = "70"  # CPU threshold
  alarm_actions       = [aws_sns_topic.alarm_notification.arn] # SNS topic ARN for alarm notifications
  ok_actions          = [aws_sns_topic.alarm_notification.arn] # SNS topic ARN for OK notifications
  dimensions          = {
    DBInstanceIdentifier = aws_db_instance.mvp_db.id
    }     
 }
