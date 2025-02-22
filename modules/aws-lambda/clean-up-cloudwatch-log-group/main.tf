resource "aws_iam_role" "lambda_role" {
  name = format("%s-%s-clean-log-group", var.tags["environment"], var.tags["project"])

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com",
        },
      },
    ],
  })
  tags = var.tags
}

resource "aws_iam_role_policy" "lambda_log_cleanup_policy" {
  name = "lambda-log-cleanup-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:DescribeLogStreams",
          "logs:DeleteLogStream"
        ],
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_lambda_function" "clean-up-cloudwatch-log-group" {
  filename         = "lambda_function.zip"
  function_name    = format("%s-%s-clean-log-group", var.tags["environment"], var.tags["project"])
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = var.runtime
  source_code_hash = filebase64sha256("./lambda_function.zip")
  timeout          = var.timeout
  tags             = var.tags
}

resource "aws_cloudwatch_event_rule" "schedule" {
  name                = format("%s-%s-clean-log-group-schedule", var.tags["environment"], var.tags["project"])
  schedule_expression = var.schedule_expression
  tags                = var.tags
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.schedule.name
  target_id = "lambda_target"
  arn       = aws_lambda_function.clean-up-cloudwatch-log-group.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.clean-up-cloudwatch-log-group.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule.arn
}