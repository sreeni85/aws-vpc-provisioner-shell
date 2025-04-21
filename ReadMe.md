# 🛠️ AWS VPC Shell Automator

A simple yet effective shell-based automation tool that creates and deletes a VPC with a public subnet in AWS. This project is ideal for DevOps learners and cloud engineers looking to get hands-on with AWS CLI scripting and infrastructure lifecycle management.

## 📌 Features

- ✅ Create VPC and subnet using AWS CLI
- 🔁 Idempotency checks to avoid duplicate creations
- 🔍 Validations for AWS CLI installation and credentials
- 🧠 Designed with best practices: variable declarations, error handling, and tagging
- 🧪 Developed with GitHub Copilot assistance (AI-powered pair programming)

---

## 📂 Files Included

| File               | Description                            |
|--------------------|----------------------------------------|
| `aws_vpc_create.sh`| Creates VPC and subnet after checks    |
| `aws_vpc_delete.sh`| Deletes VPC and subnet safely          |

---

## ⚙️ Prerequisites

- AWS CLI installed on your local machine  
- AWS credentials configured via `aws configure`  
- Necessary IAM permissions to create and delete VPCs/Subnets

---

## 🚀 Usage

### 1. Make scripts executable:

```bash
chmod +x aws_vpc_create.sh
chmod +x aws_vpc_delete.sh


2. Run the create script:
./aws_vpc_create.sh

3. Run the delete script (when needed):
./aws_vpc_delete.sh

✅ Output Sample

VPC created with ID: vpc-xxxxxxxxxxxxxxxxx
VPC tagged with Name: MyVPC
Subnet created with ID: subnet-xxxxxxxxxxxxx
Subnet tagged with Name: MySubnet



