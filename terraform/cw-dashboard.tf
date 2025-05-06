resource "aws_cloudwatch_dashboard" "startup" {
  dashboard_name = "Startup-Monitoring-Dashboard"
  dashboard_body = jsonencode({

    "widgets": [
        {
            "height": 6,
            "width": 6,
            "y": 0,
            "x": 0,
            "type": "metric",
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/ApplicationELB", "RequestCount", "AvailabilityZone", "us-east-1b", "LoadBalancer", "app/startup-alb/99ab465d2925e8e5" ],
                    [ "...", "us-east-1c", ".", "." ]
                ],
                "region": "us-east-1",
                "title": "RequestCount"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 0,
            "x": 6,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/ApplicationELB", "ConsumedLCUs", "LoadBalancer", "app/startup-alb/99ab465d2925e8e5" ]
                ],
                "view": "gauge",
                "region": "us-east-1",
                "stat": "Maximum",
                "period": 300,
                "yAxis": {
                    "left": {
                        "min": 0,
                        "max": 1
                    }
                },
                "annotations": {
                    "horizontal": [
                        {
                            "color": "#b2df8d",
                            "label": "Warning Threshold",
                            "value": 0.8,
                            "fill": "above"
                        }
                    ]
                }
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 0,
            "x": 12,
            "type": "metric",
            "properties": {
                "view": "bar",
                "metrics": [
                    [ "AWS/EC2", "CPUUtilization", "AutoScalingGroupName", "terraform-20250407205051064700000003" ]
                ],
                "region": "us-east-1"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 0,
            "x": 18,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "CWAgent", "MEM_USAGE_PERCENT", "InstanceId", "i-08f9504b40fe1b207", "AutoScalingGroupName", "terraform-20250407205051064700000003", "ImageId", "ami-0a3973bc8ed225c6b", "InstanceType", "t2.micro" ]
                ],
                "sparkline": true,
                "view": "singleValue",
                "region": "us-east-1",
                "stat": "Maximum",
                "period": 300
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 6,
            "x": 0,
            "type": "metric",
            "properties": {
                "view": "timeSeries",
                "stacked": true,
                "metrics": [
                    [ "AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", "mvp-db", { "period": 60 } ]
                ],
                "region": "us-east-1"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 6,
            "x": 6,
            "type": "metric",
            "properties": {
                "view": "timeSeries",
                "stacked": true,
                "metrics": [
                    [ "AWS/RDS", "DatabaseConnections", "DatabaseClass", "db.t3.micro", { "period": 60 } ]
                ],
                "region": "us-east-1"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 6,
            "x": 12,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/RDS", "FreeableMemory", { "region": "us-east-1", "yAxis": "right", "label": "FreeableMemory" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "us-east-1",
                "period": 60,
                "stat": "Average",
                "yAxis": {
                    "left": {
                        "label": ""
                    }
                }
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 6,
            "x": 18,
            "type": "metric",
            "properties": {
                "sparkline": true,
                "view": "singleValue",
                "metrics": [
                    [ "AWS/RDS", "FreeStorageSpace", "DBInstanceIdentifier", "mvp-db", { "period": 60, "region": "us-east-1" } ]
                ],
                "region": "us-east-1",
                "period": 300
            }
        }
    ]
}
) 
}
