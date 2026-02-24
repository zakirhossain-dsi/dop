import os
import json
import urllib.parse
import boto3
from typing import Any, Dict

sns = boto3.client("sns")

SNS_TOPIC_ARN = os.environ["SNS_TOPIC_ARN"]
TTL_SECONDS = int(os.getenv("APPROVAL_LINK_TTL_SECONDS", "3600"))


def _build_link(api_base: str, path: str, token: str) -> str:
    q = urllib.parse.urlencode({"token": token})
    return f"{api_base.rstrip('/')}/{path.lstrip('/')}?{q}"


def handler(event: Dict[str, Any], context) -> Dict[str, Any]:
    """
    Input expected from Step Function
    {
        "taskToken": "...",
        "event": {... normalized from validator...},
        "approvalApiBaseUrl": "https://....execute-api...amazonaws.com"
    }

    Output (not used much because StepFunction waits for callback):
    {
        "notified: true
    }
    """
    task_token = event.get("taskToken")
    approval_api = event.get("approvalApiBaseUrl")
    payload = event.get("event") or {}

    if not task_token or not approval_api:
        raise ValueError("Missing taskToken or approvalApiBaseUrl in input")

    user_name = payload.get("userName", "<unknown>")
    actor_arn = payload.get("actorArn", "<unknown>")
    policy_arn = payload.get("policyArn", "<unknown>")
    region = payload.get("region", "<unknown>")
    event_time = payload.get("eventTime", "<unknown>")
    approve_link = _build_link(approval_api, "/approve", task_token)
    reject_link = _build_link(approval_api, "/reject", task_token)
    subject = f"[ACTION REQUIRED] AdminAccess attached to IAM user: {user_name}"
    message = f"""
    AdministratorAccess policy was attached to an IAM user.
    User: {user_name}
    Policy: {policy_arn}
    Actor: {actor_arn}
    Time: {event_time}
    Region: {region}
    
    Approval required within {TTL_SECONDS} seconds.
    
    APPROVE (retain policy): 
    {approve_link}
    
    REJECT (auto-remove policy):
    {reject_link}
    
    If you did not expect this request, choose REJECT.    
    """.strip()

    sns.publish(
        TopicArn=SNS_TOPIC_ARN,
        Subject=subject[:100],
        Message=message
    )
    return {"notified": True}






