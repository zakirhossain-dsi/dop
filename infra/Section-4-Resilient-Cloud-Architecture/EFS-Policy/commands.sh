sudo su -
mount -t efs -o tls,iam <EFS ID>:/ /shared-storage
mount -t efs -o tls,iam fs-05566ae9e548528f6:/ /shared-storage
df -h
umount /mnt/efs