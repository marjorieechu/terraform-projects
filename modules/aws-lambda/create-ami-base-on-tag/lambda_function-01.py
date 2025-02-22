import boto3
from datetime import datetime

def lambda_handler(event, context):
    # Create EC2 client
    ec2 = boto3.client('ec2')

    # Get current date and time for naming the AMI
    current_time = datetime.now().strftime('%Y-%m-%d-%H-%M-%S')

    try:
        # Describe instances with the tag 'backup' set to 'true'
        response = ec2.describe_instances(
            Filters=[
                {'Name': 'tag:backup', 'Values': ['true']},
                {'Name': 'instance-state-name', 'Values': ['running']}
            ]
        )

        # Iterate over instances and create AMI
        for reservation in response['Reservations']:
            for instance in reservation['Instances']:
                instance_id = instance['InstanceId']
                ami_name = f"jenkins-backup-{current_time}"

                print(f"Creating AMI for Instance ID: {instance_id} with name: {ami_name}")

                # Create AMI
                create_image_response = ec2.create_image(
                    InstanceId=instance_id,
                    Name=ami_name,
                    NoReboot=True
                )

                print(f"Created AMI {create_image_response['ImageId']} for Instance {instance_id}")

        return {
            "statusCode": 200,
            "body": "AMI creation triggered for all eligible instances."
        }

    except Exception as e:
        print(f"Error creating AMI: {e}")
        return {
            "statusCode": 500,
            "body": f"Error: {e}"
        }
