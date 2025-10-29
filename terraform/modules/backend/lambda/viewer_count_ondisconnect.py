import boto3
import json

db = boto3.resource('dynamodb')
table = db.Table('viewer-count-connection-ids')

def lambda_handler(event, context):
    table.delete_item(
        Key={
            'id': event['requestContext']['connectionId']
        }
    )
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
