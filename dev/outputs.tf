output "dynamodb_contacts_arn" {
  value = module.dynamodb_contacts.table_arn
}

output "api_gateway_contacts_id" {
  value = module.api_gateway_contacts.rest_api_id
}

output "api_gateway_resource_contacts_id" {
  value = module.api_gateway_resource_contacts.resource_id
}

output "api_gateway_resource_contacts_method_post_to_dynamodb_id" {
  value = module.api_gateway_resource_contacts_method_post_to_dynamodb.method_id
}