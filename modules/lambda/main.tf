
resource "aws_lambda_function" "lab_function" {
  function_name     = "lab_function"
  filename          = "${"../lambda-code/target/helloworld-0.1.0-SNAPSHOT.jar"}"

  role              = "${aws_iam_role.lambda_apigateway_iam_role.arn}"
  handler           = "${"function.HelloLambdaHandler"}"
  source_code_hash  = "${filebase64sha256("../lambda-code/target/helloworld-0.1.0-SNAPSHOT.jar")}"
  runtime           = "java8"
}
