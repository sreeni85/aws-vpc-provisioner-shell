#!/bin/bash

# Description: Deletes a VPC and associated subnet in AWS using AWS CLI.
# Checks for CLI presence, IAM permissions, and deletes only if resources exist.

# Variables
VPC_CIDR="10.0.0.0/16"
subnet_cidr="10.0.0.0/24"
Region="us-east-1"

# Check AWS CLI installation
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install it first."
    exit 1
fi

# Check AWS CLI configuration
if ! aws configure list &> /dev/null; then
    echo "AWS CLI is not configured. Please run 'aws configure'."
    exit 1
fi

# Check AWS permissions
if ! aws ec2 describe-vpcs &> /dev/null; then
    echo "You do not have permission to access VPC information. Check your IAM permissions."
    exit 1
fi

# Get existing subnet ID
EXISTING_SUBNET=$(aws ec2 describe-subnets --filters "Name=cidr,Values=$subnet_cidr" --query 'Subnets[0].SubnetId' --output text --region $Region)

if [ "$EXISTING_SUBNET" != "None" ]; then
    echo "Deleting subnet with ID: $EXISTING_SUBNET"
    aws ec2 delete-subnet --subnet-id "$EXISTING_SUBNET" --region "$Region"
    if [ $? -ne 0 ]; then
        echo "Failed to delete subnet. Check your permissions and retry."
        exit 1
    fi
    echo "Subnet deleted successfully."
else
    echo "No matching subnet found to delete."
fi

# Get existing VPC ID
EXISTING_VPC=$(aws ec2 describe-vpcs --filters "Name=cidr,Values=$VPC_CIDR" --query 'Vpcs[0].VpcId' --output text --region $Region)

if [ "$EXISTING_VPC" != "None" ]; then
    echo "Deleting VPC with ID: $EXISTING_VPC"
    aws ec2 delete-vpc --vpc-id "$EXISTING_VPC" --region "$Region"
    if [ $? -ne 0 ]; then
        echo "Failed to delete VPC. Check for dependencies or permissions."
        exit 1
    fi
    echo "VPC deleted successfully."
else
    echo "No matching VPC found to delete."
fi
