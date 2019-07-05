resource "aws_api_gateway_rest_api" "lab_rest_api" {
    name        = "${var.api_name}"
    description = "${var.api_description}"
}
resource "aws_api_gateway_resource" "lab_resource" {
  rest_api_id = "${aws_api_gateway_rest_api.lab_rest_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.lab_rest_api.root_resource_id}"
  path_part   = "${var.resource_path}"
}
resource "aws_api_gateway_method" "lab_api_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.lab_rest_api.id}"
  resource_id   = "${aws_api_gateway_resource.lab_resource.id}"
  http_method   = "${var.http_method}"
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "lab_api_method_integration" {
  depends_on              = ["aws_api_gateway_method.lab_api_method"]
  rest_api_id             = "${aws_api_gateway_rest_api.lab_rest_api.id}"
  resource_id             = "${aws_api_gateway_resource.lab_resource.id}"
  http_method             = "${aws_api_gateway_method.lab_api_method.http_method}"
  integration_http_method = "${var.integration_http_method}"
  type                    = "MOCK"
  content_handling        = "CONVERT_TO_TEXT"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}
resource "aws_api_gateway_method_response" "lab_response_ok" {
  depends_on  = ["aws_api_gateway_method.lab_api_method", "aws_api_gateway_integration.lab_api_method_integration"]
  rest_api_id = "${aws_api_gateway_rest_api.lab_rest_api.id}"
  resource_id = "${aws_api_gateway_resource.lab_resource.id}"
  http_method = "${aws_api_gateway_method.lab_api_method.http_method}"
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}
resource "aws_api_gateway_integration_response" "lab_integration_response_ok" {
  depends_on  = ["aws_api_gateway_method_response.lab_response_ok", "aws_api_gateway_method.lab_api_method", "aws_api_gateway_integration.lab_api_method_integration"]
  rest_api_id = "${aws_api_gateway_rest_api.lab_rest_api.id}"
  resource_id = "${aws_api_gateway_resource.lab_resource.id}"
  http_method = "${aws_api_gateway_method.lab_api_method.http_method}"
  status_code = "${aws_api_gateway_method_response.lab_response_ok.status_code}"

  response_templates = {
    "application/json" = "{'message':'Did u get it, folks?'"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}