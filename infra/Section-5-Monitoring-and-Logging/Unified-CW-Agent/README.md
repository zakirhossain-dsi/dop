````md
# CloudWatch Agent on Amazon Linux 2023: journald vs `/var/log/messages`

## Overview

On **Amazon Linux 2**, system logs are commonly available in:

```bash
/var/log/messages
````

On **Amazon Linux 2023**, this path is usually **missing by default**.

That is because Amazon Linux 2023 uses **systemd-journald** as the default logging system, and traditional file-based logging with `rsyslog` is not enabled by default.

So if you configure CloudWatch Agent with:

```json
"file_path": "/var/log/messages"
```

or

```json
"file_path": "/var/log/journal-export.log"
```

the agent will fail unless that file actually exists.

---

## Why this happens

### Amazon Linux 2

* Uses traditional syslog-style logging more commonly
* `/var/log/messages` usually exists

### Amazon Linux 2023

* Uses **journald**
* Logs are viewed with:

```bash
journalctl
```

* `/var/log/messages` does **not** exist unless `rsyslog` is installed
* `/var/log/journal-export.log` is **not a default file**
* If you want `/var/log/journal-export.log`, you must create it yourself and continuously export journald logs into it

---

## Symptom

You may see that these paths are missing:

```bash
/var/log/messages
/var/log/journal-export.log
```

That is expected on a fresh Amazon Linux 2023 instance.

---

## Solutions

There are two practical solutions.

---

# Option 1: Install `rsyslog` and use `/var/log/messages`

This is the easiest option if you want CloudWatch Agent to work with a standard file path.

## Install rsyslog

```bash
sudo dnf install -y rsyslog
sudo systemctl enable --now rsyslog
```

## Verify

```bash
ls -l /var/log/messages
```

If the file exists, use this CloudWatch Agent config:

```json
{
  "agent": {
    "run_as_user": "root"
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/messages",
            "log_group_name": "/ec2/amazon-linux-2023/messages",
            "log_stream_name": "{instance_id}",
            "retention_in_days": 14,
            "timezone": "UTC"
          }
        ]
      }
    }
  }
}
```

---

# Option 2: Keep journald and export logs to a custom file

If you want to keep the native Amazon Linux 2023 logging model, create your own export file such as:

```bash
/var/log/journal-export.log
```

## Step 1: Create the file

```bash
sudo touch /var/log/journal-export.log
sudo chmod 640 /var/log/journal-export.log
```

## Step 2: Create a systemd service to export journald logs

Create this file:

```bash
/etc/systemd/system/journal-export.service
```

Content:

```ini
[Unit]
Description=Export journald to file for CloudWatch Agent
After=network.target

[Service]
ExecStart=/bin/bash -c 'journalctl -f -o short-iso >> /var/log/journal-export.log'
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

## Step 3: Enable the service

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now journal-export.service
sudo systemctl status journal-export.service
```

## Step 4: Verify the log file is being written

```bash
tail -f /var/log/journal-export.log
```

## Step 5: Use CloudWatch Agent with that file

```json
{
  "agent": {
    "run_as_user": "root"
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/journal-export.log",
            "log_group_name": "/ec2/amazon-linux-2023/system",
            "log_stream_name": "{instance_id}",
            "retention_in_days": 14,
            "timezone": "UTC"
          }
        ]
      }
    }
  }
}
```

---

## Recommended approach

### Use Option 1 if:

* you want quick compatibility with old CloudWatch Agent examples
* you want `/var/log/messages`

### Use Option 2 if:

* you want to stay closer to native Amazon Linux 2023 behavior
* you are okay managing a custom export file

---

## Helpful commands

### View journald logs directly

```bash
journalctl
```

### Show recent logs

```bash
journalctl -n 50
```

### Follow logs live

```bash
journalctl -f
```

### Check whether `/var/log/messages` exists

```bash
ls -l /var/log/messages
```

### Check whether export file exists

```bash
ls -l /var/log/journal-export.log
```

---

## Key takeaway

On **Amazon Linux 2023**, neither of these is guaranteed by default:

* `/var/log/messages`
* `/var/log/journal-export.log`

The system uses **journald** by default.

So for CloudWatch Agent file-based collection, you must either:

1. install `rsyslog` and use `/var/log/messages`, or
2. create your own exported log file from journald