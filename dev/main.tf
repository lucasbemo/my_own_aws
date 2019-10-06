########################################################################################################################
################################################################################################################# Tables
module "dynamodb_contacts" {
  source                                      = "../modules/dynamodb"

  table_name                                  = "contacts"
  hash_key                                    = "document"
}
########################################################################################################################
################################################################################################################### APIs
module "api_gateway_contacts" {
  source                                      = "../modules/api-gateway"

  api_name                                    = "Contacts"
  api_description                             = "Important Contacts"
  api_endpoint_configuration                  = "REGIONAL"  ##PRIVATE/NONE/REGIONAL
  
  api_request_validator_name                  = "request_validator_contacts"
  api_request_validator_body                  = true
  api_request_validator_parameters            = true
  
  api_path_open_api_doc                       = "../api-gateway/contacts/open-api_doc/Contacts-release-candidate-swagger-postman.json"
}

module "api_gateway_resource_contacts" {
  source                                      = "../modules/api-gateway-resource"

  rest_api_id                                 = "${module.api_gateway_contacts.rest_api_id}"
  rest_api_root_resource_id                   = "${module.api_gateway_contacts.rest_api_root_resource_id}"

  resource_path_part                          = "contacts"
}

module "api_gateway_resource_contacts_method_post_to_dynamodb" {
  source                                      = "../modules/api-gateway-method"
  
  rest_api_id                                 = "${module.api_gateway_contacts.rest_api_id}"
  resource_id                                 = "${module.api_gateway_resource_contacts.resource_id}"
  
  api_method_http_method                      = "POST"
  api_method_authorization                    = "AWS_IAM"
  api_method_key_required                     = "false"
  
  api_integration_http_method                 = "POST"
  api_integration_uri_putItem                 = "arn:aws:apigateway:us-east-1:dynamodb:action/PutItem"
  api_integration_credentials                 = "arn:aws:iam::385680495520:role/role_assume"
  api_integration_passthrough_behavior        = "WHEN_NO_TEMPLATES"
  api_integration_dynamodb_request_templates  = "../api-gateway/contacts/json_schemas/contacts_put_item_schemas.json"

  model_name                                  = "PostContact"
  model_post_template_file                    = "../api-gateway/contacts/request_templates/contacts-post-template.json"

  api_method_doc_resource_path                = "contacts"
  api_method_doc_summary                      = "Incluir Contato"
  api_method_doc_description                  = "Incluir Novo Contato"
  api_method_response_ok_doc_ok_msg           = "OK"
}
########################################################################################################################
################################################################################################################