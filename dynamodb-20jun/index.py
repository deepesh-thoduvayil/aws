def lambda_handler(event, context):
    print(event)
    target_value = int(event['target_value'])
    
    print("Lambda is Invoked with the Integer:: ", target_value)
    
    nums = [-1,0,3,5,9,12]
    
    found, index = search(nums, target_value)
    
    if found:
        statusCode = 200
        msg = 'Target value {0} found in position {1}'.format(target_value, index)
    
    else:
        statusCode = 400
        msg = 'Target value {0} was not found in the List!'.format(target_value)
    
    return {
        'statusCode': statusCode,
        'body': msg
    }
    
    
def search(nums, target_value):
    head, tail = 0, len(nums)-1
    
    while head <= tail:
        mid = (head + tail) // 2
        
        if nums[mid] == target_value:
            return (True,  mid)
        
        elif nums[mid] > target_value:
            tail = mid - 1
            
        else:
            head = mid + 1
            
    return (False, -1)