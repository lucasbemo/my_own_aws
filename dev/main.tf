module "lab_api-gateway-dynamodb" {
  source = "../modules/api-gateway-dynamodb"
  resource_path = "callme"
  http_method = "POST"
  integration_http_method = "POST"
  authorization = "POST"
}

