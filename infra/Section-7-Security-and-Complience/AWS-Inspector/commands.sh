sudo su -i
dnf update -y
dnf install -y docker
systemctl start docker
docker pull centos:8
aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 153761978087.dkr.ecr.ap-southeast-1.amazonaws.com
docker tag centos:8 153761978087.dkr.ecr.ap-southeast-1.amazonaws.com/private-app:latest
docker push 153761978087.dkr.ecr.ap-southeast-1.amazonaws.com/private-app:latest
