########################################################################################################################
################################################################################################# Flux: User -> Dynamodb
resource "aws_api_gateway_method" "api_method" {
  rest_api_id   = "${var.rest_api_id}"
  resource_id   = "${var.resource_id}"
  http_method   = "${var.api_method_http_method}"
  authorization = "${var.api_method_authorization}"
  api_key_required = "${var.api_method_key_required}"
  request_models = {
     "application/json" = "${aws_api_gateway_model.model.name}"
  }
}

resource "aws_api_gateway_integration" "api_integration_dynamodb" {
  rest_api_id             = "${var.rest_api_id}"
  resource_id             = "${var.resource_id}"
  http_method             = "${aws_api_gateway_method.api_method.http_method}"
  integration_http_method = "${var.api_integration_http_method}"
  type                    = "AWS"
  uri                     = "${var.api_integration_uri_putItem}"
  credentials             = "${var.api_integration_credentials}"
  passthrough_behavior    = "${var.api_integration_passthrough_behavior}"
  request_templates  = {
    "application/json" = "${file("${var.api_integration_dynamodb_request_templates}")}"
  }
}

########################################################################################################################
################################################################################################# Flux: Dynamodb -> User

resource "aws_api_gateway_integration_response" "integration_response" {
  rest_api_id       = "${var.rest_api_id}"
  resource_id       = "${var.resource_id}"
  http_method       = "${aws_api_gateway_method.api_method.http_method}"
  status_code       = "${aws_api_gateway_method_response.method_response_ok.status_code}"
  selection_pattern = "200"
  response_templates = {
    "application/json" = "{\"message\":\"Success\"}"
  }
}

resource "aws_api_gateway_method_response" "method_response_ok" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${var.resource_id}"

  http_method = "${aws_api_gateway_method.api_method.http_method}"
  
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
}

########################################################################################################################
################################################################################################################### Model

resource "aws_api_gateway_model" "model" {
  rest_api_id = "${var.rest_api_id}"
  name = "${var.model_name}"
  content_type = "application/json"
  schema = "${file("${var.model_post_template_file}")}"
}

########################################################################################################################
########################################################################################################## Documentation

resource "aws_api_gateway_documentation_part" "api_method_documentation" {
  location {
    type = "METHOD"
    method = "${var.api_method_http_method}"
    path = "${var.api_method_doc_resource_path}"
  }

  properties = "{\"sumary\": \"${var.api_method_doc_summary}\", \"description\": \"${var.api_method_doc_description}\"}"
  rest_api_id = "${var.rest_api_id}"

  depends_on = [
    "aws_api_gateway_method.api_method"
  ]
}

resource "aws_api_gateway_documentation_part" "api_method_response_ok_documentation" {
  location {
    type = "RESPONSE"
    method = "${var.api_method_http_method}"
    status_code = "${aws_api_gateway_method_response.method_response_ok.status_code}"
    path = "${var.api_method_doc_resource_path}"
  }

  properties = "{\"description\": \"${var.api_method_response_ok_doc_ok_msg}\"}"
  rest_api_id = "${var.rest_api_id}"

  depends_on = [
    "aws_api_gateway_method_response.method_response_ok"
  ]
}