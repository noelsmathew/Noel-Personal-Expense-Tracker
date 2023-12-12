resource "aws_cloudwatch_log_group" "wisewallet" {
  name              = "wisewallet"
  retention_in_days = 3
}

# CoRise TODO: create a new dashboard
resource "aws_cloudwatch_dashboard" "wisewallet_main" {
  dashboard_name = "wisewallet_main"

  dashboard_body = jsonencode(
    {
        
      {
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
                    [ "AWS/ElasticBeanstalk", "Visitor_Count", "EnvironmentName", "wisewallet-environment" ]
                ],
                "region": "us-east-2"
            }
        },
        {
            "type": "metric",
            "x": 6,
            "y": 0,
            "width": 6,
            "height": 6,
            "properties": {
                "metrics": [
                    [ { "expression": "SORT(METRICS(), MAX, DESC)", "label": "Expression1", "id": "e1", "visible": false } ],
                    [ { "expression": "MAX(METRICS())", "label": "Expression2", "id": "e2" } ],
                    [ "AWS/ELB", "Latency", { "region": "us-east-2", "id": "m1" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "us-east-2",
                "period": 300,
                "stat": "Average"
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 0,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": true,
                "metrics": [
                    [ "AWS/ELB", "RequestCount", { "stat": "Sum" } ]
                ],
                "region": "us-east-2"
            }
        }
    ]
}
  })
}

#CoRise TODO: create metric alters
resource "aws_cloudwatch_metric_alarm" "bot_attack" {
  alarm_name          = "bot_attack"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "$auth/register_visitor_count"
  namespace           = "wisewallet"
  period              = 60
  statistic           = "Sum"
  threshold           = 10
  alarm_description   = "The bots area attacking our forum, help us Neo!"
}

resource "aws_cloudwatch_metric_alarm" "too_busy" {
  alarm_name          = "too_busy"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUIdle"
  namespace           = "AWS/ElasticBeanstalk"
  period              = 300
  statistic           = "Average"
  alarm_description   = "Hey, I'd doing real work here, what give! I need a break!"
}