import os
import boto3
from typing import Any, Dict

iam = boto3.client("iam")

ADMIN_POLICY_ARN = os.getenv("ADMIN_POLICY_ARN", "arn:aws:iam::aws:policy/AdministratorAccess")


def handler(event: Dict[str, Any], context) -> Dict[str, Any]:
    """
    Expects event to contain userName an policyArn (from validator), but handles missing values gracefully.
    """
    user_name = event.get("userName")
    policy_arn = event.get("policyArn") or ADMIN_POLICY_ARN

    if not user_name:
        raise ValueError("Missing userName in input event")

    iam.detach_user_policy(UserName=user_name, PolicyArn=policy_arn)
    return {
        "remediated": True,
        "action": "DetachUserPolicy",
        "userName": user_name,
        "policyArn": policy_arn
    }
