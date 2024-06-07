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

# Function to list EC2 instances
def list_ec2_instances():
    ec2_client = session.client('ec2')
    response = ec2_client.describe_instances()
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            print(f"EC2 Instance ID: {instance['InstanceId']}, State: {instance['State']['Name']}, Type: {instance['InstanceType']}, AZ: {instance['Placement']['AvailabilityZone']}")

# Function to list S3 buckets
def list_s3_buckets():
    s3_client = session.client('s3')
    response = s3_client.list_buckets()
    for bucket in response['Buckets']:
        print(f"S3 Bucket Name: {bucket['Name']}")

# Function to list CloudWatch Alarms
def list_cloudwatch_alarms():
    cloudwatch_client = session.client('cloudwatch')
    response = cloudwatch_client.describe_alarms()
    for alarm in response['MetricAlarms']:
        print(f"CloudWatch Alarm Name: {alarm['AlarmName']}, State: {alarm['StateValue']}")

# List all resources
def list_all_resources():
    print("Listing EC2 Instances:")
    list_ec2_instances()
    print("\nListing S3 Buckets:")
    list_s3_buckets()
    print("\nListing CloudWatch Alarms:")
    list_cloudwatch_alarms()

# Run the function
if __name__ == "__main__":
    list_all_resources()
