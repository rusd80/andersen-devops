#
# Function returns Id's of snapshots older then defined number of days and hours
#
import json
import boto3, os, datetime

region_src = 'eu-central-1'


def lambda_handler(event, context):
    current_time = datetime.datetime.now(datetime.timezone.utc)
    client = boto3.client('iam')
    owner = boto3.client('sts').get_caller_identity()['Account']
    client = boto3.client("ec2", region_src)

    snap_list = client.describe_snapshots(OwnerIds=[owner])['Snapshots']
    result = {}
    result_list = []
    delay = (event.get('hours', 0) + event.get('days', 0) * 24) * 3600

    for snap in snap_list:
        result['Id'] = snap['SnapshotId']
        result['Size'] = snap['VolumeSize']
        result['StartTime'] = str(snap['StartTime'])
        st = snap['StartTime']
        diff = (current_time - st).seconds
        if diff > delay:
            result_list.append(result)

    return result_list
