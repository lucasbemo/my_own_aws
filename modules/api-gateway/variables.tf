variable "api_name" {
    type = "string"
    description = "Name of the API"
    default = "callme_mock_api"
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