
# Create IAM role for AWS Step Function
resource "aws_iam_role" "iam_for_sfn" {
  name = "stepFunctionSampleStepFunctionExecutionIAM"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "states.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "policy_terraform_sqs" {
  name = "stepfunctionSendMessagePolicy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Action": [
        "sqs:SendMessage",
        "sqs:ReceiveMessage"
      ],
      "Resource": "${aws_sqs_queue.terraform_queue.arn}"     
    }
  ]
}
EOF
}

resource "aws_iam_policy" "policy_invoke_lambda" {
  name        = "stepFunctionSampleLambdaFunctionInvocationPolicy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "lambda:InvokeFunction",
                "lambda:InvokeAsync"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}


// Attach policy to IAM Role for Step Function
resource "aws_iam_role_policy_attachment" "iam_for_sfn_attach_policy_invoke_lambda" {
  role       = "${aws_iam_role.iam_for_sfn.name}"
  policy_arn = "${aws_iam_policy.policy_invoke_lambda.arn}"
}

resource "aws_iam_role_policy_attachment" "iam_for_sfn_attach_policy_terraform_sqs" {
  role       = "${aws_iam_role.iam_for_sfn.name}"
  policy_arn = "${aws_iam_policy.policy_terraform_sqs.arn}"
}



// Create state machine for step function
resource "aws_sfn_state_machine" "sfn_state_machine" {
  name     = "sample-state-machine"
  role_arn = "${aws_iam_role.iam_for_sfn.arn}"

  definition = <<EOF

  {  
   "StartAt":"Send message to SQS",
   "States":{  
      "Send message to SQS":{  
        "Type":"Task",
        "Resource":"arn:aws:states:::sqs:sendMessage",
        "Parameters":{  
            "QueueUrl":"${aws_sqs_queue.terraform_queue.url}",
            "MessageBody": "Test message"
          },
        "Next": "write-dynamodb-lambda"
      },


      "write-dynamodb-lambda":{
        "Comment": "write to dynamodb", 
        "Type":"Task",
        "Resource":"${aws_lambda_function.write-dynamodb-lambda.arn}",
        "End":true
      }
    }
  }
  EOF
}