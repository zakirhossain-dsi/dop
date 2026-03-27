# This command will generate a random 128-bit key and a random initialization vector (IV) for AES-128-CBC encryption,
# and it will print the key and IV in hexadecimal format.
# You can use the key and IV to encrypt and decrypt data using AES-128-CBC.
openssl enc -aes-128-cbc -k mysecret -P

aws s3 scp ssec.txt s3://sample-bucket-for-encryption --sse-c --sse-e-key <key from the above command> \
--region ap-southeast-1 \
--profile terraform-admin