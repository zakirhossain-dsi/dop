sudo aws ecr get-login-password --region ap-southeast-1 | sudo docker login --username AWS --password-stdin 153761978087.dkr.ecr.ap-southeast-1.amazonaws.com
sudo docker tag nginx:latest 153761978087.dkr.ecr.ap-southeast-1.amazonaws.com/demo-ecr-repo:latest
sudo docker push 153761978087.dkr.ecr.ap-southeast-1.amazonaws.com/demo-ecr-repo:latest