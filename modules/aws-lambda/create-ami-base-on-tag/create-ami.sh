#!/bin/bash

AWS_REGION="us-east-1"

TAG_KEY="backup"
TAG_VALUE="true"

CURRENT_TIME=$(date -u +"%Y-%m-%d-%H-%M-%S")

log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') $1"
}

log "Starting Jenkins EC2 instance backup..."

INSTANCE_ID=$(aws ec2 describe-instances \
    --region "$AWS_REGION" \
    --filters "Name=tag:$TAG_KEY,Values=$TAG_VALUE" "Name=instance-state-name,Values=running" \
    --query "Reservations[0].Instances[0].InstanceId" \
    --output text)

if [ "$INSTANCE_ID" == "None" ]; then
    log "No EC2 instance found with tag $TAG_KEY=$TAG_VALUE. Exiting."
    exit 1
fi

log "Found EC2 instance with ID: $INSTANCE_ID"

AMI_NAME="jenkins-backup-$CURRENT_TIME"
AMI_ID=$(aws ec2 create-image \
    --region "$AWS_REGION" \
    --instance-id "$INSTANCE_ID" \
    --name "$AMI_NAME" \
    --no-reboot \
    --query "ImageId" \
    --output text)

if [ -z "$AMI_ID" ]; then
    log "Failed to create AMI. Exiting."
    exit 1
fi

log "Created AMI with ID: $AMI_ID and Name: $AMI_NAME"

aws ec2 create-tags \
    --region "$AWS_REGION" \
    --resources "$AMI_ID" \
    --tags Key=Name,Value="$AMI_NAME" Key=backup,Value=true Key=created_by,Value=shell-script

log "Added tags to AMI: $AMI_ID"

log "Jenkins EC2 instance backup completed successfully!"
