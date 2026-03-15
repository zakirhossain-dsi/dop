sudo su -
mount -t efs -o tls,iam <EFS ID>:/ /shared-storage
df -h
umount /shared-storage