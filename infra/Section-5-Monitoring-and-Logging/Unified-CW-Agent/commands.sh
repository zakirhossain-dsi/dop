sudo su -

# Commands to install and configure rsyslog on an EC2 instance
dnf install -y rsyslog
systemctl enable --now rsyslog
ls -l /var/log/messages

# Commands to install and configure the CloudWatch Agent on an EC2 instance
dnf update -y
dnf install -y amazon-cloudwatch-agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s
systemctl status amazon-cloudwatch-agent

# Documentation Referred:
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/install-CloudWatch-Agent-commandline-fleet.html
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/create-cloudwatch-agent-configuration-file-wizard.html
