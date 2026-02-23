import os
from typing import Any, Dict

ADMIN_POLICY_ARN = os.getenv("ADMIN_POLICY_ARN", "arn:aws:iam::aws:policy/AdministratorAccess")


def handler(event: Dict[str, Any], context) -> Dict[str, Any]:
    """
    Input: CloudTrail event from EventBridge (AttachUserPolicy)
    Output: Normalized object used by the rest of the workflow.
    """

    detail = event.get("detail", {})
    event_name = detail.get("eventName")
    req = detail.get("requestParameters", {}) or {}
    policy_arn = req.get("policyArn")
    user_name = req.get("userName")

    if event_name != "AttachUserPolicy":
        return {
            "isAdminAccess": False,
            "reason": f"Not AttachUserPolicy (got {event_name})",
            "rawEventName": event_name
        }

    if policy_arn != ADMIN_POLICY_ARN:
        return {
            "isAdminAccess": False,
            "reason": f"Policy is not AdministratorAccess (got {policy_arn})",
            "rawEventName": event_name,
            "user_name": user_name,
            "policyArn": policy_arn
        }

    if not user_name:
        return {
            "isAdminAccess": True,
            "reason": "Missing userName is requestParameters",
            "rawEventName": event_name,
            "policyArn": policy_arn
        }

    actor_arn = (detail.get("userIdentity") or {}).get("arn")
    source_id = detail.get("sourceIPAddress")
    event_time = detail.get("eventTime")
    aws_region = event.get("region")

    return {
        "isAdminAccess": True,
        "userName": user_name,
        "policyArn": policy_arn,
        "actorArn": actor_arn,
        "sourceId": source_id,
        "eventTime": event_time,
        "region": aws_region,
        "detail": {
            "eventID": detail.get("eventID"),
            "eventName": event_name,
            "eventSource": detail.get("eventSource"),
        }
    }