########################################################################################################################
############################################################################################################### Resource
resource "aws_api_gateway_resource" "resource" {
  rest_api_id = "${var.rest_api_id}"
  parent_id   = "${var.rest_api_root_resource_id}"
  path_part   = "${var.resource_path_part}"
}

########################################################################################################################
########################################################################################################## Documentation

resource "aws_api_gateway_documentation_part" "api_documentation_resource" {
  location {
    type = "RESOURCE"
    path = "${var.resource_path_part}"
  }

  properties = "{}"
  rest_api_id = "${var.rest_api_id}"

  depends_on = [
    "aws_api_gateway_resource.resource"
  ]
} 