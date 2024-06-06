#!/bin/bash

# Function to list resources for a given region
list_resources_in_region() {
    region=$1
    has_resources=false

    echo "Checking region: $region"

    # Check EC2 Instances
    ec2_instances=$(aws ec2 describe-instances --region $region --query "Reservations[].Instances[].[InstanceId]" --output text)
    if [ -n "$ec2_instances" ]; then
        echo "Listing EC2 Instances in region: $region"
        aws ec2 describe-instances --region $region --query "Reservations[].Instances[].[InstanceId,State.Name,InstanceType,Placement.AvailabilityZone]" --output table
        has_resources=true
    fi

    # Check S3 Buckets (S3 is global, so list them once)
    if [ "$region" == "$default_region" ]; then
        s3_buckets=$(aws s3api list-buckets --query "Buckets[].Name" --output text)
        if [ -n "$s3_buckets" ]; then
            echo "Listing S3 Buckets"
            aws s3api list-buckets --query "Buckets[].Name" --output table
            has_resources=true
        fi
    fi

    # Check CloudWatch Alarms
    cloudwatch_alarms=$(aws cloudwatch describe-alarms --region $region --query "MetricAlarms[].[AlarmName]" --output text)
    if [ -n "$cloudwatch_alarms" ]; then
        echo "Listing CloudWatch Alarms in region: $region"
        aws cloudwatch describe-alarms --region $region --query "MetricAlarms[].[AlarmName,StateValue]" --output table
        has_resources=true
    fi

    # Check RDS Instances
    rds_instances=$(aws rds describe-db-instances --region $region --query "DBInstances[].[DBInstanceIdentifier]" --output text)
    if [ -n "$rds_instances" ]; then
        echo "Listing RDS Instances in region: $region"
        aws rds describe-db-instances --region $region --query "DBInstances[].[DBInstanceIdentifier,DBInstanceStatus,DBInstanceClass,AvailabilityZone]" --output table
        has_resources=true
    fi

    # Check Lambda Functions
    lambda_functions=$(aws lambda list-functions --region $region --query "Functions[].[FunctionName]" --output text)
    if [ -n "$lambda_functions" ]; then
        echo "Listing Lambda Functions in region: $region"
        aws lambda list-functions --region $region --query "Functions[].[FunctionName,Runtime,Handler,LastModified]" --output table
        has_resources=true
    fi

    # Check DynamoDB Tables
    dynamodb_tables=$(aws dynamodb list-tables --region $region --query "TableNames" --output text)
    if [ -n "$dynamodb_tables" ]; then
        echo "Listing DynamoDB Tables in region: $region"
        aws dynamodb list-tables --region $region --query "TableNames" --output table
        has_resources=true
    fi

#    # Check IAM Roles (IAM is global, not region-specific)
#    if [ "$region" == "$default_region" ]; then
#        iam_roles=$(aws iam list-roles --query "Roles[].[RoleName,Arn]" --output text)
#        if [ -n "$iam_roles" ]; then
#            echo "Listing IAM Roles"
#            aws iam list-roles --query "Roles[].[RoleName,Arn]" --output table
#            has_resources=true
#        fi
#    fi

    if [ "$has_resources" = false ]; then
        echo "No resources found in region: $region"
    fi
}

# Get the default region
default_region=${AWS_DEFAULT_REGION:-us-east-1}

# Get list of all available regions
regions=$(aws ec2 describe-regions --query "Regions[].RegionName" --output text)

# Loop through each region and list resources
for region in $regions; do
    list_resources_in_region $region
done
