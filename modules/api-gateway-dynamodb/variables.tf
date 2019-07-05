variable "api_name" {
    type = "string"
    description = "Name of the API"
    default = "callme_api"
}
variable "api_description" {
    type = "string"
    description = "Short description about the API"
    default = "Test API"
}
variable "resource_path" {
  type = "string"
}
variable "http_method" {
  type = "string"
}
variable "authorization" {
  type = "string"
  default = "NONE"
}
variable "integration_http_method" {
  type = "string"
}
##########

variable "lambda_payload_filename" {
  default = "../lambda-code/target/helloworld-0.1.0-SNAPSHOT.jar"
}

variable "lambda_function_handler" {
  default = "function.HelloLambdaHandler"
}