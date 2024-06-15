# See https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-swagger-extensions.html for additional 
# configuration information.

# Variables for API
variable "openapi_config" {
  description = "The OpenAPI specification for the API"
  type        = any
  default     = {}
}

variable "endpoint_type" {
  type        = string
  description = "The type of the endpoint. One of - PUBLIC, PRIVATE, REGIONAL"
  default     = "REGIONAL"

  validation {
    condition     = contains(["EDGE", "REGIONAL", "PRIVATE"], var.endpoint_type)
    error_message = "Valid values for var: endpoint_type are (EDGE, REGIONAL, PRIVATE)."
  }
}

variable "disable_execute_api_endpoint" {
  type    = bool
  default = false
}

variable "vpc_endpoint_ids" {
  type        = set(string)
  description = "ID of vpc endpoint"
  default     = [""]
}

variable "description" {
  type        = string
  default     = ""
  description = "description of creating apigw"
}

# Variables for Settings
variable "logging_level" {
  type        = string
  description = "The logging level of the API. One of - OFF, INFO, ERROR"
  default     = "INFO"

  validation {
    condition     = contains(["OFF", "INFO", "ERROR"], var.logging_level)
    error_message = "Valid values for var: logging_level are (OFF, INFO, ERROR)."
  }
}

variable "metrics_enabled" {
  description = "A flag to indicate whether to enable metrics collection."
  type        = bool
  default     = true
}

variable "data_trace_enabled" {
  type    = bool
  default = true
}

variable "throttling_burst_limit" {
  type    = number
  default = 5000
}

variable "throttling_rate_limit" {
  type    = number
  default = 10000
}

variable "caching_enabled" {
  type    = bool
  default = false
}

variable "cache_ttl_in_seconds" {
  type    = number
  default = 300
}

variable "cache_data_encrypted" {
  type    = bool
  default = false
}

# Variables Stage
variable "xray_tracing_enabled" {
  description = "A flag to indicate whether to enable X-Ray tracing."
  type        = bool
  default     = false
}

variable "stage_variables" {
  # type        = list(any)
  type        = map(any)
  default     = {}
  description = "A map that defines the stage variables."
}

# See https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-logging.html for additional information
# on how to configure logging.
#   {
# 	"requestTime": "$context.requestTime",
# 	"requestId": "$context.requestId",
# 	"httpMethod": "$context.httpMethod",
# 	"path": "$context.path",
# 	"resourcePath": "$context.resourcePath",
# 	"status": $context.status,
# 	"responseLatency": $context.responseLatency,
#   "xrayTraceId": "$context.xrayTraceId",
#   "integrationRequestId": "$context.integration.requestId",
# 	"functionResponseStatus": "$context.integration.status",
#   "integrationLatency": "$context.integration.latency",
# 	"integrationServiceStatus": "$context.integration.integrationStatus",
#   "authorizeResultStatus": "$context.authorize.status",
# 	"authorizerServiceStatus": "$context.authorizer.status",
# 	"authorizerLatency": "$context.authorizer.latency",
# 	"authorizerRequestId": "$context.authorizer.requestId",
#   "ip": "$context.identity.sourceIp",
# 	"userAgent": "$context.identity.userAgent",
# 	"principalId": "$context.authorizer.principalId",
# 	"cognitoUser": "$context.identity.cognitoIdentityId",
#   "user": "$context.identity.user"
# }
variable "access_log_format" {
  description = "The format of the access log file."
  type        = string
  default     = <<EOF
{ "requestId":"$context.requestId","ip": "$context.identity.sourceIp", "caller":"$context.identity.caller", "user":"$context.identity.user","requestTime":"$context.requestTime", "httpMethod":"$context.httpMethod","resourcePath":"$context.resourcePath", "status":"$context.status","protocol":"$context.protocol", "responseLength":"$context.responseLength" }
  EOF
}

# See https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-resource-policies.html for additional
# information on how to configure resource policies.
#
# Example:
# {
#    "Version": "2012-10-17",
#    "Statement": [
#        {
#            "Effect": "Allow",
#            "Principal": "*",
#            "Action": "execute-api:Invoke",
#            "Resource": "arn:aws:execute-api:us-east-1:000000000000:*"
#        },
#        {
#            "Effect": "Deny",
#            "Principal": "*",
#            "Action": "execute-api:Invoke",
#            "Resource": "arn:aws:execute-api:region:account-id:*",
#            "Condition": {
#                "NotIpAddress": {
#                    "aws:SourceIp": "123.4.5.6/24"
#                }
#            }
#        }
#    ]
#}
variable "rest_api_policy" {
  description = "The IAM policy document for the API."
  type        = string
  default     = null
}

# variable "private_link_target_arns" {
#   type        = list(string)
#   description = "A list of target ARNs for VPC Private Link"
#   default     = []
# }

# Variables Log Group

variable "iam_tags_enabled" {
  type        = string
  description = "Enable/disable tags on IAM roles and policies"
  default     = true
}

variable "permissions_boundary" {
  type        = string
  default     = ""
  description = "ARN of the policy that is used to set the permissions boundary for the IAM role"
}

# variable "vpclink_id" {
#   type        = list(string)
#   default     = []
# }

#Variable Overall

variable "tags" {
  default     = {}
  type        = map(string)
  description = "A mapping of tags to assign to all resources."
}

variable "account" {
  type    = string
  default = null
}

variable "project" {
  type    = string
  default = null
}

variable "environment" {
  type    = string
  default = null
}

variable "name_prefix" {
  type        = string
  description = "The replication group identifier. This parameter is stored as a lowercase string."
}

variable "domain_name" {
  type    = string
  default = ""
}

# variable "regional_certificate_arn" {
#   type    = string
#   default = ""
# }

variable "nprod_cert_arn" {
  type    = string
  default = "arn:aws:acm:ap-southeast-1:503147467667:certificate/193e054d-d571-4c59-bafb-48001f59e8cb"
}

variable "prod_cert_arn" {
  type    = string
  default = "arn:aws:acm:ap-southeast-1:222128610007:certificate/46f88036-e5eb-4577-bbce-03fdc585d76e"
}

variable "certificate_arn" {
  type    = string
  default = ""
}

variable "endpoint_configuration" {
  description = "List of endpoint types. This resource currently only supports managing a single value. Valid values: EDGE or REGIONAL"
  type        = string
  default     = "REGIONAL"
  validation {
    condition     = contains(["EDGE", "REGIONAL"], var.endpoint_configuration)
    error_message = "Valid values for var: endpoint_configuration are (EDGE, REGIONAL)."
  }
}

variable "deployment_id" {
  type = string
  default = ""
}

variable "retention_in_days" {
  type    = number
  default = 0
}

variable "create_api_key" {
  type    = bool
  default = false
}

variable "create_usage_plan" {
  type    = bool
  default = false
}

variable "api_stages" {
  description = "One or more api_stages for this usage plan (multiples allowed)."
  type        = any
  default     = []
}

variable "quota_settings" {
  description = "nested block: NestingList, min items: 0, max items: 1"
  type = set(object(
    {
      limit  = number
      offset = number
      period = string
    }
  ))
  default = []
}

variable "throttle_settings" {
  description = "nested block: NestingList, min items: 0, max items: 1"
  type = set(object(
    {
      burst_limit = number
      rate_limit  = number
    }
  ))
  default = []
}

# variable "private_link_target_arns" {
#   type        = list(string)
#   description = "A list of target ARNs for VPC Private Link"
#   default     = []
# }

# variable "stage_variables" {
#   description = "Map of variables to create"
#   type = map(object({
#     vpclink1     = string
#     vpclink2     = string
#     domain1      = string
#     domain2      = string
#   }))
#   default = {}
# }

variable "burst_limit" {
  type    = number
  default = null
}

variable "rate_limit" {
  type    = number
  default = null
}

variable "path" {
  type    = string
  default = null
}
