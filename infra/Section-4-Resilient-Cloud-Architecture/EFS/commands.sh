sudo su -
mount -t efs <EFS ID>:/ /shared-storage
df -h
umount /shared-storage