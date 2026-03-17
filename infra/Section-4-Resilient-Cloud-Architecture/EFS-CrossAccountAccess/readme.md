# 📦 Cross-Account Amazon EFS Access using Terraform

This project demonstrates how to **mount an Amazon EFS file system across AWS accounts** using:

* Terraform
* IAM role assumption
* VPC peering
* AZ ID mapping (critical for cross-account)
* EFS mount helper with IAM authentication

---

# 🧠 Architecture Overview

```text
Account A (EFS Owner)
----------------------
VPC (10.10.0.0/16)
   ├── Subnet (AZ-a) → Mount Target
   ├── Subnet (AZ-b) → Mount Target
   └── EFS File System

          │  (VPC Peering)
          ▼

Account B (Consumer)
----------------------
VPC (10.20.0.0/16)
   ├── EC2 Instance (IAM Role)
   └── Mount EFS via IAM + TLS
```

---

# 🎯 Objective

* Create an **EFS file system in Account A**
* Launch an **EC2 instance in Account B**
* Allow EC2 to:

    * assume a role in Account A
    * securely mount EFS
* Support **cross-account + cross-AZ safe mounting**

---

# ⚙️ Key Concepts

## 1️⃣ Mount Target

* EFS is regional, but access happens via **mount targets**
* Each mount target:

    * lives in a subnet
    * belongs to one AZ
    * has a private IP

---

## 2️⃣ AZ ID Mapping (Critical)

AZ names differ across accounts:

| Account | AZ Name         | AZ ID     |
| ------- | --------------- | --------- |
| A       | ap-southeast-1a | apse1-az2 |
| B       | ap-southeast-1a | apse1-az1 |

👉 Therefore, we must match using **AZ ID**, not AZ name.

---

## 3️⃣ IAM Authentication for EFS

Mount command:

```bash
mount -t efs -o tls,iam,awsprofile=efs-cross fs-xxxx:/ /shared-storage
```

Required IAM permissions:

* `elasticfilesystem:ClientMount`
* `elasticfilesystem:ClientWrite`
* `elasticfilesystem:ClientRootAccess` (if using root)

---

# 🏗️ Terraform Components

## Account A (EFS Owner)

* VPC + subnets
* EFS file system
* Mount targets (one per AZ)
* EFS resource policy
* IAM role (to be assumed by Account B)

---

## Account B (Consumer)

* VPC + subnets
* EC2 instance
* IAM role for EC2
* Assume-role permission to Account A role

---

## Cross-Account

* VPC Peering
* Route tables
* Security group rules (port **2049** for NFS)

---

# 🔐 IAM Configuration

## Role in Account A (EFS access role)

Trust policy:

```json
{
  "Effect": "Allow",
  "Principal": {
    "AWS": "<EC2 Role ARN from Account B>"
  },
  "Action": "sts:AssumeRole"
}
```

Permissions:

```json
{
  "Effect": "Allow",
  "Action": [
    "elasticfilesystem:ClientMount",
    "elasticfilesystem:ClientWrite",
    "elasticfilesystem:ClientRootAccess"
  ],
  "Resource": "<EFS ARN>"
}
```

---

## EFS File System Policy

```json
{
  "Effect": "Allow",
  "Principal": {
    "AWS": "<Role ARN from Account A>"
  },
  "Action": [
    "elasticfilesystem:ClientMount",
    "elasticfilesystem:ClientWrite",
    "elasticfilesystem:ClientRootAccess"
  ]
}
```

---

# 🌐 Networking Requirements

* VPC CIDR blocks must **not overlap**
* VPC Peering must be configured
* Route tables must allow cross-VPC traffic
* Security groups must allow:

```text
TCP 2049 (NFS)
```

---

# 🧩 AZ Matching Logic (Terraform)

To ensure correct mount target selection:

```hcl
efs_mount_target_zone_ids = {
  for idx, mt in aws_efs_mount_target.mt :
  idx => local.account_a_az_map[aws_subnet.account_a_public[idx].availability_zone]
}
```

Then:

```hcl
selected_mount_target_index = [
  for idx, zid in local.efs_mount_target_zone_ids :
  idx if zid == local.ec2_subnet_az_id
][0]
```

👉 This ensures EC2 connects to the **correct mount target in the same AZ**

---

# 🚀 How to Deploy

## 1️⃣ Configure AWS profiles

```bash
aws configure --profile account-a
aws configure --profile account-b
```

---

## 2️⃣ Initialize Terraform

```bash
terraform init
```

---

## 3️⃣ Apply infrastructure

```bash
terraform apply
```

---

# 🖥️ EC2 Setup

Install required packages:

```bash
sudo dnf install -y amazon-efs-utils awscli python3-botocore
```

Create AWS config:

```bash
mkdir -p /root/.aws
cat <<EOF > /root/.aws/config
[profile efs-cross]
role_arn = <Account A Role ARN>
credential_source = Ec2InstanceMetadata
region = ap-southeast-1
EOF
```

---

# 🔗 Mount EFS

```bash
sudo mkdir -p /shared-storage

sudo mount -t efs \
  -o tls,iam,awsprofile=efs-cross \
  fs-xxxxxxxx:/ /shared-storage
```

---

# ✅ Verification

```bash
df -h
```

Expected:

```text
127.0.0.1:/ /shared-storage
```

---

Test write:

```bash
echo "hello" > /shared-storage/test.txt
cat /shared-storage/test.txt
```

---

# 🧪 Troubleshooting

## Permission denied

* Check:

    * `ClientWrite`
    * `ClientRootAccess`
    * POSIX permissions

---

## Mount fails

* Check:

    * security group (port 2049)
    * route tables
    * VPC peering status

---

## Profile not found

* Ensure:

    * `/root/.aws/config` exists
    * `botocore` is installed

---

# 💡 Best Practices

* Avoid default VPC (CIDR overlap issue)
* Use **EFS Access Points** for better control
* Always create mount targets in multiple AZs
* Use IAM instead of open access

---

# 📌 Key Takeaways

* EFS is accessed via **mount targets (not directly)**
* Cross-account requires:

    * IAM role assumption
    * AZ ID matching
* IAM + POSIX permissions both matter
* `ClientRootAccess` affects root behavior

---
