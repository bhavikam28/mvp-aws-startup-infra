# This code creates a CloudWatch dashboard with various widgets to monitor EC2 and RDS instances.

resource "aws_cloudwatch_dashboard" "startup" {
  dashboard_name = "Startup-Monitoring-Dashboard"
  dashboard_body = jsonencode({
    widgets= [
        {
            "height": 12,
            "width": 5,
            "y": 0,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/ApplicationELB", "HTTPCode_Target_4XX_Count", "TargetGroup", "targetgroup/tf-20250407235643341100000001/46d3639b4b29de0c", "LoadBalancer", "app/startup-alb/99ab465d2925e8e5", { "region": "us-east-1", "label": "HTTPCode_Target_4XX_Count", "id": "m1" } ],
                    [ ".", "TargetResponseTime", ".", ".", ".", ".", { "region": "us-east-1", "label": "TargetResponseTime", "stat": "Average", "id": "m2" } ],
                    [ ".", "RequestCount", "AvailabilityZone", "us-east-1b", ".", ".", { "region": "us-east-1", "label": "RequestCount", "id": "m4" } ]
                ],
                "sparkline": true,
                "view": "singleValue",
                "region": "us-east-1",
                "period": 60,
                "stat": "Sum",
                "title": "Application Load Balancer"
            }
        },
        {
            "height": 6,
            "width": 7,
            "y": 0,
            "x": 5,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/EC2", "CPUUtilization", "InstanceId", "i-05a988714eb2b58ab", { "region": "us-east-1", "label": "CPUUtilization" } ],
                    [ "CWAgent", "MEM_USAGE_PERCENT", ".", ".", "AutoScalingGroupName", "terraform-20250407205051064700000003", "ImageId", "ami-0a3973bc8ed225c6b", "InstanceType", "t2.micro", { "region": "us-east-1", "label": "MEM_USAGE_PERCENT" } ]
                ],
                "sparkline": true,
                "view": "gauge",
                "region": "us-east-1",
                "period": 60,
                "stat": "Average",
                "title": "EC2- CPU & Memory",
                "annotations": {
                    "horizontal": [
                        {
                            "color": "#d62728",
                            "label": "Critical",
                            "value": 90,
                            "fill": "above"
                        }
                    ]
                },
                "yAxis": {
                    "left": {
                        "min": 0,
                        "max": 100
                    }
                }
            }
        },
        {
            "height": 6,
            "width": 7,
            "y": 6,
            "x": 5,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/EC2", "EBSReadBytes", "InstanceId", "i-05a988714eb2b58ab", { "region": "us-east-1" } ],
                    [ ".", "EBSWriteBytes", ".", ".", { "region": "us-east-1", "yAxis": "right" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "us-east-1",
                "title": "EC2-EBS Read/ Write",
                "period": 60,
                "stat": "Sum"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 5,
            "x": 18,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/AutoScaling", "GroupInServiceInstances", "AutoScalingGroupName", "terraform-20250407205051064700000003", { "region": "us-east-1" } ]
                ],
                "sparkline": true,
                "view": "gauge",
                "region": "us-east-1",
                "period": 60,
                "stat": "Minimum",
                "yAxis": {
                    "left": {
                        "min": 1,
                        "max": 5
                    }
                },
                "annotations": {
                    "horizontal": [
                        {
                            "color": "#b2df8d",
                            "label": "Healthy",
                            "value": 1,
                            "fill": "above"
                        }
                    ]
                },
                "title": "Auto Scaling Group"
            }
        },
        {
            "height": 12,
            "width": 6,
            "y": 0,
            "x": 12,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", "mvp-db", { "region": "us-east-1", "stat": "Average" } ],
                    [ ".", "DatabaseConnections", ".", ".", { "region": "us-east-1" } ],
                    [ ".", "FreeStorageSpace", ".", ".", { "region": "us-east-1" } ],
                    [ ".", "FreeableMemory", ".", ".", { "period": 60 } ]
                ],
                "sparkline": true,
                "view": "singleValue",
                "region": "us-east-1",
                "period": 60,
                "title": "RDS- CPU, Connections, Space & Memory",
                "stat": "Sum"
            }
        },
        {
            "height": 5,
            "width": 6,
            "y": 0,
            "x": 18,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/RDS", "ReadLatency", "DBInstanceIdentifier", "mvp-db", { "region": "us-east-1" } ],
                    [ ".", "WriteLatency", ".", ".", { "region": "us-east-1", "yAxis": "right" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "us-east-1",
                "period": 60,
                "stat": "p99",
                "title": "RDS- Read/ Write"
            }
        }
    ]
})

}