import boto3
import logging
from flask import current_app

logger = logging.getLogger(__name__)

def increment_visit_counter(RegisterSurvey):
    if not current_app.testing:
        try:
            cw_client = boto3.client('cloudwatch')
            cw_client.put_metric_data(
                MetricData=[         
                    {             
                        'MetricName': f"${RegisterSurvey}_visitor_count",             
                        'Unit': 'Count',             
                        'Value': 1.0         
                    },     
                ],     
                Namespace='wisewallet' )
        except Exception as e:
            logging.warn("Failed to send metrics to AWS", exc_info=e)
    