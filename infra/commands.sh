ssh -i ec2-key.pem ec2-user@100.26.34.44
systemctl status amazon-ssm-agent
aws ssm start-session --target i-0d5ed4a60ef98bc09 \
--profile=terraform-admin \
--region=ap-southeast-1

aws ssm get-parameters-by-path --path "/payments-app" --recursive