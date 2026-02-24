import json
import boto3
from typing import Any, Dict

sfn = boto3.client("stepfunctions")


def _response(status: int, body: Dict[str, Any]) -> Dict[str, Any]:
    return {"statusCode": status, "headers": {"Content-Type": "application/json"}, "body": json.dumps(body)}


def handler(event: Dict[str, Any], context) -> Dict[str, Any]:
    """
    Works with API Gateway HTTP API (payload v2.0).
    Expected:
        GET /approve?token=...
        GET /reject?token=...
    """
    raw_path = event.get("rawPath", "")
    qs = event.get("queryStringParameters", {}) or {}
    token = qs.get("token")

    if not token:
        return _response(400, {"error": "Missing token"})

    decision = None
    if raw_path.endswith("/approve"):
        decision = "APPROVE"
    elif raw_path.endswith("/reject"):
        decision = "REJECT"
    else:
        return _response(404, {"error": f"Unknown path: {raw_path}"})

    try:
        sfn.send_task_success(taskToken=token, output=json.dumps({"decision": decision}))
    except sfn.exceptions.InvalidToken:
        return _response(400, {"error": "Invalid or expired token"})
    except Exception as e:
        return _response(500, {"error": f"Failed to submit decision: {str(e)}"})

    return _response(200, {"message": f"Decision recorded: {decision}"})
