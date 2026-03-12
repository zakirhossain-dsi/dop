## Approach 1: Bastion host with direct key access
You need to **copy the private key (`terraform-key.pem`) from your local machine to the public EC2 instance** first. After that, you can SSH from the public EC2 to the private EC2.

The common tool for this is **`scp` (secure copy)**.

---

### Step 1 — Copy the key to the public EC2

Run this **from your local machine**, not from EC2.

```bash
scp -i terraform-key.pem terraform-key.pem ec2-user@<PUBLIC_EC2_IP>:~
```

Example:

```bash
scp -i terraform-key.pem terraform-key.pem ec2-user@13.212.178.96:~
```

This copies the key to:

```
/home/ec2-user/terraform-key.pem
```

on the public EC2.

### Step 2 — SSH into the public EC2

```bash
ssh -i terraform-key.pem ec2-user@13.212.178.96
```

### Step 3 — Fix the key permission

SSH requires strict permissions.

```bash
chmod 400 terraform-key.pem
```

### Step 4 — SSH to the private EC2

Now connect to the private instance using its **private IP**:

```bash
ssh -i terraform-key.pem ec2-user@<PRIVATE_EC2_PRIVATE_IP>
```

Example:

```bash
ssh -i terraform-key.pem ec2-user@172.31.100.10
```
### Step 5: Then on the private EC2, test S3

```bash
aws s3 ls s3://<bucket-name> \
--endpoint-url https://bucket.<vpc endpoint dns name>
```
Example:

```bash
aws s3 ls s3://<bucket-name> \
--endpoint-url https://bucket.vpce-0142b4695a7d167b3-1ild1boi.s3.ap-southeast-1.vpce.amazonaws.com
```
---

### Resulting connection flow

```
Local machine
      │
      │ ssh
      ▼
Public EC2 (bastion host)
      │
      │ ssh using private IP
      ▼
Private EC2
```

This pattern is called a **bastion host architecture**.

---
## Approach 2: SSH agent forwarding

### Step 1: load the key into your local SSH agent

On your **local machine**:

```bash
ssh-add terraform-key.pem
```

If you get an error like “Could not open a connection to your authentication agent”, run:

```bash
eval "$(ssh-agent -s)"
ssh-add terraform-key.pem
```

### Step 2: connect to the public EC2 with agent forwarding

From your local machine:

```bash
ssh -A ec2-user@13.212.178.96
```

If you need the identity file explicitly:

```bash
ssh -A -i terraform-key.pem ec2-user@13.212.178.96
```

### Step 3: verify forwarding on the public EC2

On the **public EC2**, run:

```bash
ssh-add -L
```

If forwarding works, you should see your public key listed.

If you see:

```text
The agent has no identities.
```

then the forwarding is not working.

### Step 4: connect to the private EC2

From the public EC2:

```bash
ssh ec2-user@172.31.100.144
```
### Step 5: Then on the private EC2, test S3

```bash
aws s3 ls s3://<bucket-name> \
--endpoint-url https://bucket.<vpc endpoint dns name>
```
Example:

```bash
aws s3 ls s3://<bucket-name> \
--endpoint-url https://bucket.vpce-0142b4695a7d167b3-1ild1boi.s3.ap-southeast-1.vpce.amazonaws.com
```