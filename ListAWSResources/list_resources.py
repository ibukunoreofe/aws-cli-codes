import boto3
import os

# Get AWS credentials from environment variables
aws_access_key_id = os.getenv('AWS_ACCESS_KEY_ID')
aws_secret_access_key = os.getenv('AWS_SECRET_ACCESS_KEY')
aws_default_region = os.getenv('AWS_DEFAULT_REGION', 'us-east-1')

# Initialize a session using your AWS profile
session = boto3.Session(
    aws_access_key_id=aws_access_key_id,
    aws_secret_access_key=aws_secret_access_key,
    region_name=aws_default_region
)

# Function to list all resources using the Resource Groups Tagging API
def list_all_resources():
    tagging_client = session.client('resourcegroupstaggingapi')
    paginator = tagging_client.get_paginator('get_resources')
    page_iterator = paginator.paginate()

    for page in page_iterator:
        for resource in page['ResourceTagMappingList']:
            print(f"Resource ARN: {resource['ResourceARN']}")
            if 'Tags' in resource:
                for tag in resource['Tags']:
                    print(f"  Tag Key: {tag['Key']}, Tag Value: {tag['Value']}")
            print()

# Run the function
if __name__ == "__main__":
    list_all_resources()
