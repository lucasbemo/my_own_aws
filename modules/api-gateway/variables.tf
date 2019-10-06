variable "api_name" {
    type = "string"
    description = "Name of the API"
}

variable "api_description" {
    type = "string"
    description = "Short description about the API"
}

variable "api_endpoint_configuration" {
  type = "string"
}

variable "api_request_validator_name" {
  type = "string"
}

variable "api_request_validator_body" {
  type = "string"
}

variable "api_request_validator_parameters" {
  type = "string"
}

variable "api_path_open_api_doc" {
  type = "string"
}