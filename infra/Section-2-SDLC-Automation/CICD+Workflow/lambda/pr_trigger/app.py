import os
import boto3

codebuild = boto3.client('codebuild')
codecommit = boto3.client('codecommit')

PROJECT = os.environ['CODEBUILD_PROJECT']
REPO = os.environ['REPO_NAME']


def handler(event, context):
    detail = event.get('detail', {})
    pr_id = detail.get('pullRequestId')

    if not pr_id:
        return {"ok": True, "msg": "No pullRequestId in event"}

    # Start build and pass PR context
    resp = codebuild.start_build(projectName=PROJECT,
                                 sourceVersion=detail.get("sourceCommit"),
                                 environmentVariablesOverride=[
                                     {'name': 'PULL_REQUEST_ID', 'value': str(pr_id), 'type': 'PLAINTEXT'},
                                     {'name': 'REPO_NAME', 'value': REPO, 'type': 'PLAINTEXT'}]
                                 )

    build_id = resp['build']['id']

    codecommit.post_comment_for_pull_request(
        pullRequestId=pr_id,
        repositoryName=REPO,
        beforeCommitId=detail.get('destinationCommit', 'UNKNOWN'),
        afterCommitId=detail.get('sourceCommit', 'UNKNOWN'),
        content=f"✅ Build started with ID: `{build_id}`")

    return {"ok": True, "build_id": build_id, "pullRequestId": pr_id}
