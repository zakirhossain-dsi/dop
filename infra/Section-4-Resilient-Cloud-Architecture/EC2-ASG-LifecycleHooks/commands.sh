aws autoscaling complete-lifecycle-action \
    --lifecycle-hook-name demo-asg-log-backup \
    --auto-scaling-group-name demo-asg \
    --lifecycle-action-result CONTINUE \
    --instance-id i-083252c37179b0037 \
    --region ap-southeast-1 \
    --profile terraform-admin