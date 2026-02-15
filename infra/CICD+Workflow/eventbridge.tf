# PR events → Lambda (start build + comment)
resource "aws_cloudwatch_event_rule" "pr_events" {
  name        = "${var.project_name}-pr-events"
  description = "Trigger build on CodeCommit PR events"

  event_pattern = jsonencode({
    "source" : ["aws.codecommit"],
    "resources" : [aws_codecommit_repository.code_repo.arn],
    "detail-type" : ["CodeCommit Pull Request State Change"]
    detail : {
      "event" : ["pullRequestCreated"],
      "pullRequestStatus" : ["Open"]
    }
  })
}

resource "aws_cloudwatch_event_target" "pr_events_to_lambda" {
  rule = aws_cloudwatch_event_rule.pr_events.name
  arn  = aws_lambda_function.pr_trigger.arn
}

resource "aws_lambda_permission" "allow_events_pr" {
  statement_id  = "AllowEventBridgeInvokePR"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.pr_trigger.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.pr_events.arn
}

# CodeBuild state change → Lambda (comment result)
resource "aws_cloudwatch_event_rule" "codebuild_events" {
  name        = "${var.project_name}-codebuild-events"
  description = "React to CodeBuild success/failure events"

  event_pattern = jsonencode({
    "source" : ["aws.codebuild"],
    "detail-type" : ["CodeBuild Build State Change"],
    "detail" : {
      "build-status" : ["SUCCEEDED", "FAILED"],
      "project-name" : [aws_codebuild_project.build.name]
    }
  })
}

resource "aws_cloudwatch_event_target" "codebuild_events_to_lambda" {
  rule = aws_cloudwatch_event_rule.codebuild_events.name
  arn  = aws_lambda_function.build_result.arn
}

resource "aws_lambda_permission" "allow_events_codebuild" {
  statement_id  = "AllowEventBridgeInvokeCodeBuild"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.build_result.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.codebuild_events.arn
}