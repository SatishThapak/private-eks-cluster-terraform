# 🚀 EKS Cluster End-to-End Deployment

This project automates the complete provisioning of an Amazon EKS (Elastic Kubernetes Service) cluster using Terraform. It includes infrastructure setup, IAM roles and policies, networking, compute resources, and secure access via a jump host.

## 📦 Project Overview

The goal of this project is to provide a modular, reusable, and production-ready Terraform configuration for deploying an EKS cluster with:

- VPC and subnet provisioning
- IAM roles and policies for EKS and EC2
- EKS cluster and managed node groups
- Secure SSH access via a jump host
- Cluster autoscaler IAM policy

## 🧱 Architecture
<img width="466" height="428" alt="Screenshot from 2025-09-04 15-22-54" src="https://github.com/user-attachments/assets/c01df051-2731-40e7-a459-d247f3886a9d" />

## ⚙️ Prerequisites

- Terraform ≥ 1.3
- AWS CLI configured with credentials
- SSH key pair for jump host access
- IAM user/role with EKS and EC2 provisioning permissions

## 🚀 Usage Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/eks-cluster-end_to_end.git
cd eks-cluster-end_to_end

2. Customize Variables

project_name  = "Demo"
environment   = "dev"
region        = "us-east-1"
instance_type = "t3.medium"
ami_id        = "ami-0b6c6ebed2801a5cb"
availability_zone="us-east-1"
cidr_block = "10.0.0.0/16"
cluster_name = "dev"
iam_role = "user_satish"
instance_name = "jump_host"
vpc_name = "main"

public_subnets = {
  "public-1a" = {
    cidr = "10.0.1.0/24"
    az   = "us-east-1a"
  }
  "public-1b" = {
    cidr = "10.0.2.0/24"
    az   = "us-east-1b"
  }
}

private_subnets = {
  "private-1a" = {
    cidr = "10.0.3.0/24"
    az   = "us-east-1a"
  }
  "private-1b" = {
    cidr = "10.0.4.0/24"
    az   = "us-east-1b"
  }
}

3. Initialize Terraform
terraform init

4. Review the Plan
terraform plan

5. Apply the Configuration
terraform apply

🔐 Accessing the Cluster
SSH into Jump Host
ssh -i /path/to/jump_host-key.pem ec2-user@<jump-host-public-ip>

Verify Cluster Access
kubectl get nodes
