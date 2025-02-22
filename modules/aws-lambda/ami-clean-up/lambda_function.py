import boto3

ec2 = boto3.client('ec2')

def lambda_handler(event, context):
    try:
        response = ec2.describe_images(
            Filters=[
                {'Name': 'name', 'Values': ['jenkins-backup-*']}
            ],
            Owners=['self']
        )

        images = response['Images']
        images.sort(key=lambda x: x['CreationDate'], reverse=True)

        if len(images) <= 2:
            print("No AMIs to delete. Only 2 or fewer AMIs are present.")
            return {
                "statusCode": 200,
                "body": "No AMIs to delete. Cleanup skipped."
            }

        images_to_delete = images[2:]  
        deleted_amis = [] 

        for image in images_to_delete:
            ami_id = image['ImageId']
            ami_name = image['Name']
            print(f"Deregistering AMI: {ami_id} (Name: {ami_name})")
            deleted_amis.append(ami_id)

            ec2.deregister_image(ImageId=ami_id)

            for block_device in image.get('BlockDeviceMappings', []):
                if 'Ebs' in block_device:
                    snapshot_id = block_device['Ebs']['SnapshotId']
                    print(f"Deleting Snapshot: {snapshot_id}")
                    ec2.delete_snapshot(SnapshotId=snapshot_id)

        print(f"Deleted AMIs: {', '.join(deleted_amis)}")

        return {
            "statusCode": 200,
            "body": f"Cleanup complete. Deleted AMIs: {', '.join(deleted_amis)}"
        }

    except Exception as e:
        print(f"Error: {e}")
        return {
            "statusCode": 500,
            "body": f"Error: {e}"
        }
