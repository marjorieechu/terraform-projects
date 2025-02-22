import boto3
from datetime import datetime, timezone

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')

    current_time = datetime.now(timezone.utc).strftime('%Y-%m-%d-%H-%M-%S')

    try:
        response = ec2.describe_instances(
            Filters=[
                {'Name': 'tag:backup', 'Values': ['true']},
                {'Name': 'instance-state-name', 'Values': ['running']}
            ]
        )

        for reservation in response['Reservations']:
            for instance in reservation['Instances']:
                instance_id = instance['InstanceId']
                ami_name = f"jenkins-backup-{current_time}"

                print(f"Creating AMI for Instance ID: {instance_id} with name: {ami_name}")

                create_image_response = ec2.create_image(
                    InstanceId=instance_id,
                    Name=ami_name,
                    NoReboot=True
                )

                ami_id = create_image_response['ImageId']

                print(f"Created AMI {ami_id} for Instance {instance_id}")

                ec2.create_tags(
                    Resources=[ami_id],
                    Tags=[
                        {'Key': 'Name', 'Value': ami_name},
                        {'Key': 'backup', 'Value': 'true'},
                        {'Key': 'created_by', 'Value': 'Lambda'}
                    ]
                )

                print(f"Added tags to AMI {ami_id}")

        return {
            "statusCode": 200,
            "body": "AMI creation and tagging completed for all eligible instances."
        }

    except Exception as e:
        print(f"Error creating AMI: {e}")
        return {
            "statusCode": 500,
            "body": f"Error: {e}"
        }
