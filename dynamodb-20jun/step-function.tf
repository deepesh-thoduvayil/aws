
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



# // Create state machine for step function
# resource "aws_sfn_state_machine" "sfn_state_machine" {
#   name     = "sample-state-machine"
#   role_arn = "${aws_iam_role.iam_for_sfn.arn}"

#   definition = <<EOF

#     {
#     "StartAt": "InvokeLambdaState",
#     "States": {
#       "InvokeLambdaState": {
#         "Type": "Task",
#         "Resource": "${aws_lambda_function.myLambda.arn}",
#         "Parameters": {
#           "operation":"create",
#           "tableName":"myDB",
#           "payload":{
#               "Item":{
#                   "id":"1",
#                   "name":"John Cena",
#                   "profession":"Wrestler"
#               }
#           }
#         },
#         "Next": "CheckStatusFromLambda"
#       },
#       "CheckStatusFromLambda": {
#         "Type": "Choice",
#         "Choices": [
#           {
#             "Variable": "$.statusCode",
#             "NumericEquals": 200,           
#             "Next": "SuccessState"
#           },
#           {
#             "Variable": "$.statusCode",
#             "NumericEquals": 400,           
#             "Next": "FailedState"
#           }
#         ]
#       },
#       "SuccessState": {
#         "Type": "Pass",
#         "End": true
#       },
#       "FailedState": {
#         "Type": "Fail"
#       }
#     }
#   }
#   EOF
# }