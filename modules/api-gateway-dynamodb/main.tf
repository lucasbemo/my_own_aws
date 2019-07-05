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
  api_key_required = "true"
  request_models = {
     "application/json" = "${aws_api_gateway_model.post-sample.name}"
  }
}
resource "aws_api_gateway_integration" "lab_integration_dynamodb" {
  rest_api_id             = "${aws_api_gateway_rest_api.lab_rest_api.id}"
  resource_id             = "${aws_api_gateway_resource.lab_resource.id}"
  http_method             = "${aws_api_gateway_method.lab_api_method.http_method}"
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:us-east-1:dynamodb:action/PutItem"
  credentials             = "${aws_iam_role.post-sample.arn}"
  passthrough_behavior = "WHEN_NO_TEMPLATES"
  request_templates  = {
    "application/json" = "${file("request_templates/post-sample.json")}"
  }
}
resource "aws_api_gateway_integration_response" "post-sample" {
  rest_api_id       = "${aws_api_gateway_rest_api.lab_rest_api.id}"
  resource_id       = "${aws_api_gateway_resource.lab_resource.id}"
  http_method       = "${aws_api_gateway_method.lab_api_method.http_method}"
  status_code       = "${aws_api_gateway_method_response.post-sample.status_code}"
  selection_pattern = "200"
  response_templates = {
    "application/json" = "{'message':'Success'}"
  }
}
resource "aws_api_gateway_method_response" "post-sample" {
  rest_api_id = "${aws_api_gateway_rest_api.lab_rest_api.id}"
  resource_id = "${aws_api_gateway_resource.lab_resource.id}"
  http_method = "${aws_api_gateway_method.lab_api_method.http_method}"
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
}
resource "aws_api_gateway_model" "post-sample" {
  rest_api_id = "${aws_api_gateway_rest_api.lab_rest_api.id}"
  name = "PostSample"
  description = "post-sample"
  content_type = "application/json"
  schema = <<EOF
{
  "type" : "object",
  "properties" : {
    "key": { "type": "string" }
  }
}
EOF
}
############################
resource "aws_dynamodb_table" "lab_dynamo" {
  name           = "lab_dynamodb"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "primary_key"
  attribute {
    name = "primary_key"
    type = "S"
  }

  stream_enabled = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
}
##########################3
resource "aws_lambda_function" "lab_function" {
  function_name     = "lab_function"
  filename          = "${var.lambda_payload_filename}"

  role              = "${aws_iam_role.lambda_apigateway_iam_role.arn}"
  handler           = "${var.lambda_function_handler}"
  source_code_hash  = "${filebase64sha256(var.lambda_payload_filename)}"
  runtime           = "java8"
}
