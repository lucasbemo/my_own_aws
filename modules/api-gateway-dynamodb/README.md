# AWS API Gateway Module
This module creates an AWS API Gateway, including a Mock andpoint.

## Use in this same project

```
module "dev-api-gateway" {
  source = "../modules/api-gateway"
  resource_path = "callme"
  http_method = "GET"
  integration_http_method = "GET"
  authorization = "GET"
}
```

## Use form github

```
module "dev-api-gateway" {
  source = "github.com/lucasbemo/hello-terraform-module/modules/api-gateway"
  resource_path = "callme"
  http_method = "GET"
  integration_http_method = "GET"
  authorization = "GET"
}
```