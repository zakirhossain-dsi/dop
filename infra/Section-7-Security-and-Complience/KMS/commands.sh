aws kms list-keys \
--region ap-southeast-1 \
--profile terraform-admin

aws kms encrypt \
--key-id c2da626f-41e5-4cf0-84b2-ba4050ccc3f7 \
--plaintext fileb://secret.txt \
--region ap-southeast-1 \
--profile terraform-admin

aws kms decrypt \
--ciphertext-blob AQICAHjJYl3DpCwt7h4BPpTsfdi+XflTNrCF1PgEzpUNkjbmwQGNJisYtZPEqApPp9HyaHhUAAAAazBpBgkqhkiG9w0BBwagXDBaAgEAMFUGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMigIMQ4hjeCqlC/VzAgEQgCi0nO5CcrM6+5jk5AIIRPPRqFUaQzSOt7S1L+or1Xcclr+MQe9vjFtg \
--region ap-southeast-1 \
--profile terraform-admin

# The ciphtertext-blob is the output of the encrypt command, and it is a base64-encoded string.
# The decrypt command will return the plaintext, which is the original secret that was base64 encrypted.