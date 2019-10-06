## Flux Going into
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

## Flux Back to client

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

## Other resources

resource "aws_api_gateway_model" "model" {
  rest_api_id = "${var.rest_api_id}"
  name = "${var.model_name}"
  content_type = "application/json"
  schema = "${file("${var.model_post_template_file}")}"
}