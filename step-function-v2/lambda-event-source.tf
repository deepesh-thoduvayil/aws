# Give the lambda access to read messages from SQS queues
resource "aws_iam_role_policy_attachment" "lambda_sqs_role_policy" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}

# Event source from SQS
# TRIGGER LAMBDA ON MESSAGE TO SQS
resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  batch_size       = 1
  event_source_arn = "${aws_sqs_queue.terraform_queue.arn}"
  enabled          = true
  function_name    = "${aws_lambda_function.read-event-log-lambda.arn}"
}