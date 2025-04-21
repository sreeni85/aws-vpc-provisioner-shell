#!/bin/bash

# Description: This script creates a VPC in AWS with the specified CIDR block and tags it with the provided name.
# - Create a VPC
# - Create a subnet in the VPC

# - Verify if user has AWS CLI installed, user might be using windows, linux or mac
# - verify if user has AWS installed
########

# Variables
VPC_CIDR="10.0.0.0/16"
subnet_cidr="10.0.0.0/24"
Region="us-east-1"
VPC_NAME="MyVPC"
Subnet_name="MySubnet"
SUBNET_AZ="us-east-1a"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null
then
    echo "AWS CLI could not be found. Please install it to proceed."
    exit 1
fi
# Check if AWS CLI is configured
if ! aws configure list &> /dev/null
then
    echo "AWS CLI is not configured. Please run 'aws configure' to set it up."
    exit 1
fi
# Check if user has permission to create VPC
if ! aws ec2 describe-vpcs &> /dev/null
then
    echo "You do not have permission to create a VPC. Please check your IAM permissions."
    exit 1
fi
# Check if VPC with the same CIDR block already exists
EXISTING_VPC=$(aws ec2 describe-vpcs --filters "Name=cidr,Values=$VPC_CIDR" --query 'Vpcs[0].VpcId' --output text)
if [ "$EXISTING_VPC" != "None" ]; then
    echo "A VPC with CIDR block $VPC_CIDR already exists with ID: $EXISTING_VPC"
    exit 1
fi
# Check if subnet with the same CIDR block already exists
EXISTING_SUBNET=$(aws ec2 describe-subnets --filters "Name=cidr,Values=$subnet_cidr" --query 'Subnets[0].SubnetId' --output text)
if [ "$EXISTING_SUBNET" != "None" ]; then
    echo "A subnet with CIDR block $subnet_cidr already exists with ID: $EXISTING_SUBNET"
    exit 1
fi

# Create a VPC
VPC_ID=$(aws ec2 create-vpc --cidr-block $VPC_CIDR --region $Region --query 'Vpc.VpcId' --output text)
if [ $? -ne 0 ]; then
    echo "Failed to create VPC. Please check your AWS CLI configuration and permissions."
    exit 1
fi
echo "VPC created with ID: $VPC_ID"
# Tag the VPC
aws ec2 create-tags --resources $VPC_ID --tags Key=Name,Value=$VPC_NAME --region $Region
if [ $? -ne 0 ]; then
    echo "Failed to tag VPC. Please check your AWS CLI configuration and permissions."
    exit 1
fi
echo "VPC tagged with Name: $VPC_NAME"
# Create a subnet in the VPC
SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $subnet_cidr --availability-zone $SUBNET_AZ --region $Region --query 'Subnet.SubnetId' --output text)
if [ $? -ne 0 ]; then
    echo "Failed to create subnet. Please check your AWS CLI configuration and permissions."
    exit 1
fi
echo "Subnet created with ID: $SUBNET_ID"

# Tag the subnet
aws ec2 create-tags --resources $SUBNET_ID --tags Key=Name,Value=$Subnet_name --region $Region
if [ $? -ne 0 ]; then
    echo "Failed to tag subnet. Please check your AWS CLI configuration and permissions."
    exit 1
fi 
echo "Subnet tagged with Name: $Subnet_name"




