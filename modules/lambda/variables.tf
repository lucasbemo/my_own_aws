variable "lambda_name" {
    type = "string"
    description = "Lambda Labs name."
}
variable "lambda_description" {
    type = "string"
    description = "Short description about the Lambda"
    default = "Lambda Labs description."
}
variable "tags" {
    type = "map"

    default = {
      App = "lab_"
      Environment = "dev"
  }
}
variable "lambda_payload_filename" {
  default = "../lambda-code/target/helloworld-0.1.0-SNAPSHOT.jar"
}

variable "lambda_function_handler" {
  default = "helloworld.HelloLambdaHandler"
}

variable "lambda_runtime" {
  default = "java8"
}