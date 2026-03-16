sudo su -
mount -t efs -o tls,iam,awsprofile=efs-cross <EFS ID>:/ /shared-storage
df -h
umount /shared-storage