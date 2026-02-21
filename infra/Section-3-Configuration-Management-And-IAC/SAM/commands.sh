aws s3 mb s3://zakir-sam-test
sam package --template-file template.yaml --output-template-file serverless-output.yaml --s3-bucket zakir-sam-test --region ap-southeast-1
sam deploy --template-file serverless-output.yaml --stack-name sam-test --capabilities CAPABILITY_IAM --region ap-southeast-1