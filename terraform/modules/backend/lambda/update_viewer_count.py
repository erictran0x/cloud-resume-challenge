import os
import boto3
import json

db = boto3.resource('dynamodb')
cids_table = db.Table('viewer-count-connection-ids')
count_table = db.Table('viewer-count')

API_INVOKE_URL = os.environ.get('API_INVOKE_URL')

def update_viewer_count():
    response = count_table.get_item(
        Key={
            'id': 'count'
        }
    )
    item = response.get('Item')
    if item:
        result = int(item['value']) + 1
        count_table.update_item(
            Key={
                'id': 'count'
            },
            UpdateExpression='SET #key = :val1',
            ExpressionAttributeValues={
                ':val1': result
            },
            ExpressionAttributeNames={
                '#key': 'value'
            }
        )
    else:
        result = 1
        count_table.put_item(
            Item={
                'id': 'count',
                'value': result
            }
        )
    return result

def broadcast(count):
    response = cids_table.scan(ProjectionExpression='id')
    connections = response['Items']

    # check for additional pages if table is large
    while 'LastEvaluatedKey' in response:
        response = cids_table.scan(
            ProjectionExpression='connectionId',
            ExclusiveStartKey=response['LastEvaluatedKey']
        )
        connections.extend(response['Items'])

    apigw = boto3.client('apigatewaymanagementapi', endpoint_url=API_INVOKE_URL)

    message = json.dumps({'action': 'broadcast', 'message': count}).encode('utf-8')
    print('connections=', connections)
    for item in connections:
        id = item['id']
        try:
            apigw.post_to_connection(ConnectionId=id, Data=message)
        except apigw.exceptions.GoneException:
            print(f'Connection {id} is gone, deleting...')
            cids_table.delete_item(Key={'id': id})
        except Exception as e:
            print(f'Error sending message to {id}: {e}')

def lambda_handler(event, context):
    num_times = len(event)
    result = None
    for _ in range(num_times):
        result = update_viewer_count()
    if result is not None:
        broadcast(result)
    return {
        'statusCode': 200,
        'body': 'Broadcast successful'
    }
