version: 0.2

phases:
  install:
    runtime-versions:
      java: corretto17
  build:
    commands:
      - echo "Building with Maven..."
      - mvn -B clean install
  post_build:
    commands:
      - echo "Uploading JAR(s) to S3..."
      - ls -lah target || true
      # Upload all jars found (adjust if you want a specific jar name)
      - |
        for f in target/*.jar; do
          aws s3 cp "$f" "s3://${artifact_bucket}/${artifact_prefix}/$(basename $f)"
        done