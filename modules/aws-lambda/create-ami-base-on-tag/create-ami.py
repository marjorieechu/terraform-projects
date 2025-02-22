import boto3
from datetime import datetime, timezone

# AWS Region
AWS_REGION = "us-east-1"

# Tag key and value to identify the EC2 instance
TAG_KEY = "backup"
TAG_VALUE = "true"

# Initialize Boto3 clients
ec2_client = boto3.client("ec2", region_name=AWS_REGION)

def log(message):
    """Log messages with timestamps."""
    print(f"{datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M:%S')} {message}")

def find_instance_with_tag(tag_key, tag_value):
    """Find the first EC2 instance with the specified tag."""
    response = ec2_client.describe_instances(
        Filters=[
            {"Name": f"tag:{tag_key}", "Values": [tag_value]},
            {"Name": "instance-state-name", "Values": ["running"]}
        ]
    )
    reservations = response.get("Reservations", [])
    if reservations:
        return reservations[0]["Instances"][0]["InstanceId"]
    return None

def create_ami(instance_id, ami_name):
    """Create an AMI from the specified EC2 instance."""
    response = ec2_client.create_image(
        InstanceId=instance_id,
        Name=ami_name,
        NoReboot=True
    )
    return response["ImageId"]

def tag_ami(ami_id, tags):
    """Add tags to the created AMI."""
    ec2_client.create_tags(
        Resources=[ami_id],
        Tags=tags
    )

def main():
    log("Starting Jenkins EC2 instance backup...")

    # Find the EC2 instance with the specified tag
    instance_id = find_instance_with_tag(TAG_KEY, TAG_VALUE)
    if not instance_id:
        log(f"No EC2 instance found with tag {TAG_KEY}={TAG_VALUE}. Exiting.")
        return

    log(f"Found EC2 instance with ID: {instance_id}")

    # Generate the AMI name
    current_time = datetime.now(timezone.utc).strftime("%Y-%m-%d-%H-%M-%S")
    ami_name = f"jenkins-backup-{current_time}"

    # Create the AMI
    try:
        ami_id = create_ami(instance_id, ami_name)
        log(f"Created AMI with ID: {ami_id} and Name: {ami_name}")

        # Tag the AMI
        tags = [
            {"Key": "Name", "Value": ami_name},
            {"Key": "backup", "Value": "true"},
            {"Key": "created_by", "Value": "python-script"}
        ]
        tag_ami(ami_id, tags)
        log(f"Added tags to AMI: {ami_id}")

    except Exception as e:
        log(f"Error creating AMI: {e}")
        return

    log("Jenkins EC2 instance backup completed successfully!")

if __name__ == "__main__":
    main()
