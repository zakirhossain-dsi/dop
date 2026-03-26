ssh -i ec2-key.pem ec2-user@100.26.34.44
systemctl status amazon-ssm-agent
aws ssm start-session --target i-0d5ed4a60ef98bc09 \
--profile=terraform-admin \
--region=ap-southeast-1

aws ssm get-parameters-by-path --path "/payments-app" --recursive

aws dax describe-clusters --query "Clusters[*].ClusterDiscoveryEndpoint" \
--profile=terraform-admin \
--region=ap-southeast-1

cd /usr/share/nignx/html
systemctl status nginx
curl -I <domain-name>
nslookup <domain-name>

aws s3 mb s3://zakir

stress -c 4
top

chmod 400 "terraform-key.pem"
cat /etc/fstab
mount

mount -t luster -o noatime, flock <DNS name>@tcp:/<mount name> /<directory name to be mounted>

aws configure sso
#SSO session name (Recommended): nishat
#SSO start URL [None]: https://d-90671b1e5c.awsapps.com/start
#SSO region [None]: ap-southeast-1
#SSO registration scopes [sso:account:access]:

aws configure list-profiles
aws sso login --profile nishat
aws s3 ls --profile nishat

# SAML Tracer