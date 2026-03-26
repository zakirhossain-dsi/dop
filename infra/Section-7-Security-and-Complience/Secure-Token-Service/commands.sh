# URL to get STS for a given role
curl http://169.254.169.254/latest/meta-data/iam/security-credentials/<role-name>

aws sts get-session-token --duration-seconds 900 \
--profile terraform-admin \
--region ap-southeast-1

aws sts assume-role \
--role-arn arn:aws:iam::<account-id>:role/<role-name> \
--role-session-name <session-name> \
--profile terraform-admin \
--region ap-southeast-1