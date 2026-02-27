import json


def handler(event, context):
    # Process each record in the event
    for record in event['Records']:
        print(record['eventID'])
        print(record['eventName'])
        print("DynamoDB Record: " + json.dumps(record['dynamodb']))

    return {
        'statusCode': 200,
        'body': 'Stream processed successfully!'
    }
