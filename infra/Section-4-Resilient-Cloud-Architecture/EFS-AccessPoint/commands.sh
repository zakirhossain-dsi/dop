sudo su -
mount -t efs <EFS ID>:/ /shared-storage
mount -t efs -o tls,accesspoint=<Access Point ID> <EFS ID>:/ /app-1
mount -t efs -o tls,accesspoint=<Access Point ID> <EFS ID>:/ /app-2

df -h
umount /shared-storage
umount /app-1
umount /app-2