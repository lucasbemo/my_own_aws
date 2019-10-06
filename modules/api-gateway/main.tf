########################################################################################################################
#################################################################################################################### API
resource "aws_api_gateway_rest_api" "rest_api" {
  name            = "${var.api_name}"
  description     = "${var.api_description}"
  policy          = "${data.aws_iam_policy_document.policy_document_rest_api.json}"

  endpoint_configuration {
    types         = ["${var.api_endpoint_configuration}"]
  }
}

data "aws_iam_policy_document" "policy_document_rest_api" {
  statement {
    actions = ["execute-api:Invoke"]
    resources = ["*"]
    principals {
      identifiers = ["*"]
      type = "*"
    }
  }
}

resource "aws_api_gateway_request_validator" "request_validator" {
  name                        = "${var.api_request_validator_name}"
  rest_api_id                 = "${aws_api_gateway_rest_api.rest_api.id}"
  validate_request_body       = "${var.api_request_validator_body}"
  validate_request_parameters = "${var.api_request_validator_parameters}"
}

########################################################################################################################
########################################################################################################## Documentation

resource "aws_api_gateway_documentation_part" "api_doc" {
  location {
    type = "API"
  }

  properties = "${file("${var.api_path_open_api_doc}")}"
  rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}"

  depends_on = [
    "aws_api_gateway_rest_api.rest_api"
  ]
}