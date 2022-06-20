import json
import boto3

def lambda_handler(event, context):
    client = boto3.resource("dynamodb")
    table = client.Table("myDB")
    
    #itemData = json.loads(event['body'])

    try:
      response = table.put_item(
        Item={
              'id': '1',
              'name': 'John Cena',
              'profession': 'Wrestler'
          }
      )
      response = {'statusCode':200}
    except:
      response = {'statusCode':400}

    return response
    #x = {'id': '1', 'name': 'John Cena', 'profession': 'Wrestler'}
    #itemData = json.load(x)
    #guild = table.get_item(Key={'id':itemData['id']})
    
    #If Guild Exists, update
    # if 'Item' in guild:
    #   table.update_item(Key=itemData)
      
    #   responseObject = {}
    #   responseObject['statusCode'] = 200
    #   responseObject['headers'] = {}
    #   responseObject['headers']['Content-Type'] = 'application/json'
    #   responseObject['body'] = json.dumps('Updated Guild!')
      
    #   return responseObject
    
    #New Guild, Insert Guild
    # table.put_item(Item=itemData)
    
    # responseObject = {}
    # responseObject['statusCode'] = 200
    # responseObject['headers'] = {}
    # responseObject['headers']['Content-Type'] = 'application/json'
    # responseObject['body'] = json.dumps('Inserted Guild!')
      
    # return responseObject