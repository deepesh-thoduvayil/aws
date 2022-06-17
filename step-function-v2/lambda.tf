
// Create archives for AWS Lambda functions which will be used for Step Function
data "archive_file" "read-event-log" {
  type        = "zip"
  output_path = "./read-event-log/archive.zip"
  source_file = "./read-event-log/index.js"
}


// Create IAM role for AWS Lambda
resource "aws_iam_role" "iam_for_lambda" {
  name = "stepFunctionSampleLambdaIAM"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]

}
EOF
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.iam_for_lambda.id

  policy = file("policy.json")
}


// Create AWS Lambda functions
// Lambda function to read event-log, which gets triggered by a message drops in sqs queue
resource "aws_lambda_function" "read-event-log-lambda" {
  filename         = "./read-event-log/archive.zip"
  function_name    = "read-event-log-lambda"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "index.handler"
  runtime          = "nodejs16.x"
}

resource "aws_lambda_function" "write-dynamodb-lambda" {
  filename         = "./write-dynamodb/archive.zip"
  function_name    = "write-dynamodb-lambda"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "index.handler"
  runtime          = "nodejs16.x"
}
