curl -s "http://<gateway-host-public-ip>/?activationRegion=ap-southeast-1&no_redirect"

sudo mount -t nfs -o nolock,hard <storage-gateway-host-private-id>:/storage-gateway-bucket-153761978087 /mnt/s3gateway

aws storagegateway list-file-shares --gateway-arn arn:aws:storagegateway:ap-southeast-1:153761978087:gateway/sgw-CF384EA6 \
--region=ap-southeast-1 \
--profile=terraform-admin

aws storagegateway describe-nfs-file-shares --file-share-arn-list arn:aws:storagegateway:ap-southeast-1:153761978087:share/share-824D0AE2 \
--region=ap-southeast-1 \
--profile=terraform-admin

aws storagegateway refresh-cache \
--file-share-arn arn:aws:storagegateway:ap-southeast-1:153761978087:share/share-824D0AE2 \
--region=ap-southeast-1 \
--profile=terraform-admin