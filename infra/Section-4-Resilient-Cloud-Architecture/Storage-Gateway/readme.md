# 📦 AWS Storage Gateway (S3 File Gateway) – Terraform Setup

## 🧠 Overview

This project provisions an **AWS Storage Gateway (File Gateway)** using Terraform and exposes an **NFS file share backed by an S3 bucket**.

It allows applications to interact with Amazon S3 using standard file system operations (NFS), without directly using S3 APIs.

---

## 🏗️ Architecture

```
Client EC2 (NFS Mount)
        ↓
Storage Gateway (EC2 Appliance)
        ↓ (asynchronous upload)
Amazon S3 Bucket
```

---

## 🔑 Key Concepts

### 🔹 Storage Gateway

* A **managed appliance** (running on EC2 in this setup)
* Acts as a bridge between file-based access and AWS storage
* Handles:

    * caching
    * buffering
    * upload to S3

👉 Think of it as a **file server**

---

### 🔹 File Share (NFS)

* A **mountable NFS directory**
* Backed by an S3 bucket
* Exposed via the gateway

👉 Think of it as a **shared folder inside the server**

---

### 🔹 Relationship

```
Storage Gateway (server)
    └── File Share (folder)
            └── S3 Bucket (storage)
```

👉 One gateway can host multiple file shares
👉 Each file share maps to an S3 bucket or prefix

---

## ⚙️ Components Created

* EC2 instance (Storage Gateway appliance)
* EBS volume (cache disk, minimum 150 GiB)
* S3 bucket (backend storage)
* IAM role (for S3 access)
* NFS file share
* Security group (NFS + activation ports)

---

## 🔄 Data Flow Behavior

### ✅ Gateway → S3

* Writes are first stored in **cache (EBS)**
* Uploaded to S3 **asynchronously**
* Delay is expected

---

### ⚠️ S3 → Gateway

* Changes made directly in S3 are **NOT immediately visible**
* Requires cache refresh:

```bash
aws storagegateway refresh-cache \
  --file-share-arn <file-share-arn>
```

---

## 📂 Mount Instructions

From a client EC2 instance:

```bash
sudo mkdir -p /mnt/s3gateway

sudo mount -t nfs -o nolock,hard \
<gateway-private-ip>:/<file-share-path> \
/mnt/s3gateway
```

Example:

```bash
sudo mount -t nfs -o nolock,hard \
172.31.19.181:/storage-gateway-bucket \
/mnt/s3gateway
```

---

## ⚠️ Important Notes

### 1. NFS Configuration

* Use `nolock` (File Gateway does not support NFS locking)
* Required ports:

    * 2049 (NFS)
    * 111 (RPC)
    * 20048 (mountd)

---

### 2. Client Access Control

Ensure `client_list` matches your VPC CIDR:

```hcl
client_list = ["172.31.0.0/16"]
```

---

### 3. Cache Disk Requirement

* Minimum **150 GiB EBS volume**
* Used for:

    * frequently accessed files
    * upload buffer

---

### 4. Activation Key Handling

* Activation key is retrieved via:

```bash
curl "http://<gateway-ip>/?activationRegion=<region>&no_redirect"
```

* Must match the region (e.g., `ap-southeast-1`)

---

### 5. Gateway Initialization Delay

* Gateway takes time to boot
* Add wait before activation in Terraform

---

## 🚨 Common Issues & Fixes

| Issue                        | Cause                       | Fix                         |
| ---------------------------- | --------------------------- | --------------------------- |
| Activation fails             | Gateway not ready           | Add delay (time_sleep)      |
| Mount hangs                  | Wrong CIDR or ports blocked | Fix SG + client_list        |
| "No such file or directory"  | Wrong mount path            | Use correct file share path |
| File not visible in S3       | Async upload                | Wait                        |
| S3 file not visible in mount | Cache not refreshed         | Run `refresh-cache`         |

---

## 🚀 Key Learnings

* File Gateway = **NFS → S3 translator with cache**
* Gateway handles **all communication with S3**
* File share is the **access layer**
* S3 is **not a real-time filesystem**

---

## 🎯 Interview Summary

> AWS Storage Gateway File Gateway allows applications to access Amazon S3 using standard file protocols like NFS or SMB, with a local cache for low-latency access and asynchronous data transfer to S3.

---

## 🔥 Limitations

* One gateway supports **either NFS or SMB**, not both
* S3 updates are not instantly reflected (requires refresh)
* Not suitable for real-time shared filesystem use cases

---

## 📌 Next Improvements

* Add SMB support (separate gateway with Active Directory)
* Enable lifecycle policies (S3 → Glacier)
* Add CloudWatch monitoring
* Convert into reusable Terraform module

---

## 👨‍💻 Usage

```bash
terraform init
terraform plan
terraform apply
```

---

## 📎 Author

This project was created for hands-on practice with:

* AWS Storage Gateway
* S3 File Gateway
* Terraform automation

---