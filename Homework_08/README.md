Optional homework:
Create a script that uses aws cli or powershell.
What this script should do:
- Collect a list of EBS Snapshot Id, StartTime and size
- Show a list of Snapshots that are older then N days or hours
- Optional: filter by Tag: Value
- Optional: add option for copy selected Snapshot to S3
- You can come up with your own case

This task is done using AWS Lambda Function:
- Collect a list of EBS Snapshot Id, StartTime and size
- Show a list of Snapshots that are older then N days or hours

Lambda function was created with AWS Console. Also lambda requires a special role.

Command:
```
aws lambda invoke --function-name=my_lambda --region=eu-central-1 --cli-binary-format raw-in-base64-out --payload '{"days": 0, "hours": 12}' lambda_output.txt
```
Result:
```
cat lambda_output.txt
[{"Id": "snap-068360ab20ce04c29", "Size, ": 8, "StartTime": "2021-12-19 11:30:01.308000+00:00"}, {"Id": "snap-068360ab20ce04c29", "Size, ": 8, "StartTime": "2021-12-19 11:30:01.308000+00:00"}, {"Id": "snap-068360ab20ce04c29", "Size, ": 8, "StartTime": "2021-12-19 11:30:01.308000+00:00"}]
```