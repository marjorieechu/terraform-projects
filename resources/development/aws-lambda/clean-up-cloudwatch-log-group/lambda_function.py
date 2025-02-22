import boto3

# Initialize Boto3 client
logs_client = boto3.client('logs')

def lambda_handler(event, context):
    try:
        log_groups = [
            '/aws/lambda/jenkins-master-backup',
            '/aws/lambda/hello_lambda'
        ]
        retention_limit = 3

        for log_group_name in log_groups:
            print(f"Processing log group: {log_group_name}")

            response = logs_client.describe_log_streams(
                logGroupName=log_group_name,
                orderBy='LastEventTime',
                descending=True
            )

            log_streams = response.get('logStreams', [])

            if len(log_streams) <= retention_limit:
                print(f"No log streams to delete in {log_group_name}. Total log streams: {len(log_streams)}")
                continue

            log_streams_to_delete = log_streams[retention_limit:]
            deleted_log_streams = []

            for stream in log_streams_to_delete:
                log_stream_name = stream['logStreamName']
                print(f"Deleting log stream: {log_stream_name} from log group: {log_group_name}")

                logs_client.delete_log_stream(
                    logGroupName=log_group_name,
                    logStreamName=log_stream_name
                )
                deleted_log_streams.append(log_stream_name)

            print(f"Deleted log streams from {log_group_name}: {', '.join(deleted_log_streams)}")

        return {
            "statusCode": 200,
            "body": "Cleanup complete for all specified log groups."
        }

    except logs_client.exceptions.ResourceNotFoundException as e:
        print(f"Error: Log group not found. {e}")
        return {
            "statusCode": 404,
            "body": f"Error: Log group not found. {e}"
        }
    except Exception as e:
        print(f"Error during cleanup: {e}")
        return {
            "statusCode": 500,
            "body": f"Error: {e}"
        }
