// Create state machine for step function
resource "aws_sfn_state_machine" "sfn_state_machine-2" {
  name     = "sample-state-machine-2"
  role_arn = "${aws_iam_role.iam_for_sfn.arn}"

  definition = <<EOF

    {
        "StartAt": "InvokeLambdaState",
        "States": {
            "InvokeLambdaState": {
            "Type": "Task",
            "Resource": "${aws_lambda_function.myLambda2.arn}",
            "Parameters": {
                "id":"1",
                "name":"John Cena",
                "profession":"Wrestler"
            },
            "Next": "CheckStatusFromLambda"
            },
            "CheckStatusFromLambda": {
            "Type": "Choice",
            "Choices": [
                {
                "Variable": "$.statusCode",
                "NumericEquals": 200,           
                "Next": "SuccessState"
                },
                {
                "Variable": "$.statusCode",
                "NumericEquals": 400,           
                "Next": "FailedState"
                }
            ]
            },
            "SuccessState": {
            "Type": "Pass",
            "End": true
            },
            "FailedState": {
            "Type": "Fail"
            }
        }
    
  }
  EOF
}