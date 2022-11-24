import json
import boto3
import logging
from botocore.exceptions import ClientError

logger = logging.getLogger(__name__)

def update_count(table, keyName):
    response = table.update_item(
        Key={'ID': keyName},
        UpdateExpression="ADD CountAmount :value",
        ExpressionAttributeValues={':value': 1},
        ReturnValues="ALL_NEW")
    return response

def lambda_handler(event, context):
    dynamoDb = boto3.resource('dynamodb')
    table = dynamoDb.Table('visitor_counter')
    keyName = 'visits'
    try:
        response = update_count(table, keyName)
    except ClientError as err:
        logger.error(
            "Couldn't update visitor count for domain %s in table visitor_counter. Here's why: %s: %s",
            keyName,
            err.response['Error']['Code'], err.response['Error']['Message'])
        raise
    else:
        CountAmount = int(response.get("Attributes").get("CountAmount"))
        return {
            "statusCode": 200,
            'headers': {
            'Access-Control-Allow-Headers': '*',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': '*'
        },
            "body": json.dumps({"CountAmount": CountAmount})
        }