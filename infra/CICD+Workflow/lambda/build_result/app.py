import os
import boto3

codebuild = boto3.client("codebuild")
codecommit = boto3.client("codecommit")

REPO = os.environ["REPO_NAME"]


def _get_env(build):
    envs = build.get("environment", {}).get("environmentVariables", [])
    return {e["name"]: e.get("value", "") for e in envs}


def _get_commits(pr_id):
    pr = codecommit.get_pull_request(pullRequestId=str(pr_id))["pullRequest"]
    print(pr)
    target = pr["pullRequestTargets"][0]
    before_commit = target["destinationCommit"]
    after_commit = target["sourceCommit"]
    return before_commit, after_commit


def handler(event, context):
    detail = event.get("detail", {})
    build_id = detail.get("build-id")
    status = detail.get("build-status")

    if not build_id:
        return {"ok": True, "msg": "No build-id in event"}

    builds = codebuild.batch_get_builds(ids=[build_id]).get("builds", [])
    if not builds:
        return {"ok": False, "msg": f"Build not found: {build_id}"}

    env = _get_env(builds[0])
    pr_id = env.get("PULL_REQUEST_ID")

    # If build wasn't started by our PR-trigger lambda, skip
    if not pr_id:
        return {"ok": True, "msg": "No PULL_REQUEST_ID in build env; ignoring"}

    msg = "✅ Build succeeded" if status == "SUCCEEDED" else f"❌ Build failed ({status})"
    before_commit, after_commit = _get_commits(pr_id)
    codecommit.post_comment_for_pull_request(
        pullRequestId=str(pr_id),
        repositoryName=REPO,
        beforeCommitId=before_commit,
        afterCommitId=after_commit,
        content=f"{msg} for build `{build_id}`"
    )

    return {"ok": True, "build_id": build_id, "status": status, "pullRequestId": pr_id}