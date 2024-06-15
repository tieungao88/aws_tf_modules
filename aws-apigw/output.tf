output "id" {
  description = "The ID of the REST API"
  value       = aws_api_gateway_rest_api.this[0].id
}

# output "root_resource_id" {
#   description = "The resource ID of the REST API's root"
#   value       = module.this.enabled ? aws_api_gateway_rest_api.this[0].root_resource_id : null
# }

output "created_date" {
  description = "The date the REST API was created"
  value       = aws_api_gateway_rest_api.this[0].created_date
}

output "execution_arn" {
  description = <<EOF
    The execution ARN part to be used in lambda_permission's source_arn when allowing API Gateway to invoke a Lambda 
    function, e.g., arn:aws:execute-api:eu-west-2:123456789012:z4675bid1j, which can be concatenated with allowed stage, 
    method and resource path.The ARN of the Lambda function that will be executed.
    EOF
  value       = aws_api_gateway_rest_api.this[0].execution_arn
}

output "arn" {
  description = "The ARN of the REST API"
  value       = aws_api_gateway_rest_api.this[0].arn
}

output "invoke_url" {
  description = "The URL to invoke the REST API"
  value       = aws_api_gateway_stage.this[0].invoke_url
}

output "stage_arn" {
  description = "The ARN of the gateway stage"
  value       = aws_api_gateway_stage.this[0].arn
}

output "deployment_id" {
  description = "The DeploymentID of the REST API"
  value       = aws_api_gateway_deployment.this[0].id
}

output "regional_domain_name" {
  value = try(aws_api_gateway_domain_name.this[0].regional_domain_name, "")
}
output "cloudfront_domain_name" {
  description = "Hostname created by Cloudfront"
  value       = try(aws_api_gateway_domain_name.this[0].cloudfront_domain_name, "")
}

output "usage_plan_key_value" {
  value = try(aws_api_gateway_usage_plan_key.this[0].value, "")
}

output "api_key_value" {
  value = try(aws_api_gateway_api_key.this[0].value, "")
}