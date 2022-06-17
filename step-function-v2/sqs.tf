# 1.CREATE AN SQS QUEUE
resource "aws_sqs_queue" "terraform_queue" {
  name = "my-sqs-queue"
}

# 2.CREATE A LAMBDA TRIGGER
resource "aws_lambda_permission" "allows_sqs_to_trigger_lambda" {
  statement_id  = "AllowExecutionFromSQS"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.read-event-log-lambda.function_name}"
  principal     = "sqs.amazonaws.com"
  source_arn    = "${aws_sqs_queue.terraform_queue.arn}"
}

# 3.CREATE LAMBDA PERMISSION
resource "aws_iam_policy" "lambda_logging" {
  name = "lambda_logging"
  path = "/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
        "Action": [
            "sqs:DeleteMessage",
            "sqs:ReceiveMessage",
            "sqs:GetQueueAttributes"
        ],
        "Resource": "*",
        "Effect": "Allow"
    },
    {
      "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}