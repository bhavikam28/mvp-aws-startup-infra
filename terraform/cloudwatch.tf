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
