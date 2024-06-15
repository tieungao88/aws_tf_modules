locals {
  regional_certificate_arn = var.environment == "prod" || var.environment == "stag" ? var.prod_cert_arn : var.nprod_cert_arn
}
# Create Rest API
resource "aws_api_gateway_rest_api" "this" {
  count = local.enabled ? 1 : 0
  body  = var.openapi_config
  name  = var.endpoint_type == "PRIVATE" ? "${var.environment}.${var.account}.${var.project}.${var.name_prefix}.internal" : "${var.environment}.${var.account}.${var.project}.${var.name_prefix}.public"

  endpoint_configuration {
    types            = [var.endpoint_type]
    vpc_endpoint_ids = local.vpc_endpoint_enabled ? var.vpc_endpoint_ids : null
  }

  disable_execute_api_endpoint = var.disable_execute_api_endpoint
  description                  = var.description

  put_rest_api_mode = var.endpoint_type == "PRIVATE" ? "merge" : "overwrite"

  tags = merge(
    {
      "Name" = var.endpoint_type == "PRIVATE" ? "${var.environment}.${var.account}.${var.project}.${var.name_prefix}.internal" : "${var.environment}.${var.account}.${var.project}.${var.name_prefix}.public"
    },
    var.tags
  )
}

# Create API Policy
resource "aws_api_gateway_rest_api_policy" "this" {
  count       = local.create_rest_api_policy ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.this[0].id
  policy      = var.rest_api_policy
  depends_on = [
    aws_api_gateway_rest_api.this
  ]
}

# Create API deployment
resource "aws_api_gateway_deployment" "this" {
  count       = local.enabled ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.this[0].id
  depends_on  = [aws_api_gateway_rest_api_policy.this, aws_api_gateway_rest_api.this[0]]
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.this[0].body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create Stage
resource "aws_api_gateway_stage" "this" {
  count         = local.enabled ? 1 : 0
  deployment_id = length(var.deployment_id) > 0 ? var.deployment_id : aws_api_gateway_deployment.this[0].id
  rest_api_id   = aws_api_gateway_rest_api.this[0].id
  # stage_name           = module.this.stage
  xray_tracing_enabled = var.xray_tracing_enabled
  # tags                 = module.this.tags
  stage_name = var.environment

  # variables = {
  #   # vpc_link_id = local.vpc_link_enabled ? aws_api_gateway_vpc_link.this[0].id : null
  #   # vpc_link_id = local.vpc_link_enabled ? var.vpclink : null
  # }
  variables = var.stage_variables
  dynamic "access_log_settings" {
    for_each = local.create_log_group ? [1] : []
    content {
      destination_arn = local.log_group_arn
      format          = replace(var.access_log_format, "\n", "")
    }
  }
}

# Set the logging, metrics and tracing levels for all methods
resource "aws_api_gateway_method_settings" "all" {
  count       = local.enabled ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.this[0].id
  stage_name  = aws_api_gateway_stage.this[0].stage_name
  method_path = "*/*"

  settings {
    metrics_enabled        = var.metrics_enabled
    logging_level          = var.logging_level
    data_trace_enabled     = var.data_trace_enabled
    throttling_burst_limit = var.throttling_burst_limit
    throttling_rate_limit  = var.throttling_rate_limit
    caching_enabled        = var.caching_enabled
    cache_ttl_in_seconds   = var.cache_ttl_in_seconds
    cache_data_encrypted   = var.cache_data_encrypted
  }
}

# Optionally create a VPC Link to allow the API Gateway to communicate with private resources (e.g. ALB)
# resource "aws_api_gateway_vpc_link" "this" {
#   count       = local.vpc_link_enabled ? 1 : 0
#   name        = module.this.id
#   description = "VPC Link for ${module.this.id}"
#   target_arns = var.private_link_target_arns
# }

resource "aws_api_gateway_domain_name" "this" {
  count                    = length(var.domain_name) > 0 ? 1 : 0
  certificate_arn          = var.endpoint_configuration == "EDGE" ? var.certificate_arn : null
  regional_certificate_arn = var.endpoint_configuration == "REGIONAL" ? local.regional_certificate_arn : null
  domain_name              = var.domain_name
  endpoint_configuration {
    types = [var.endpoint_configuration]
  }
}

resource "aws_api_gateway_base_path_mapping" "this" {
  count       = length(var.domain_name) > 0 ? 1 : 0
  api_id      = aws_api_gateway_rest_api.this[0].id
  domain_name = aws_api_gateway_domain_name.this[0].domain_name
  stage_name  = aws_api_gateway_stage.this[0].stage_name
}

resource "aws_api_gateway_usage_plan" "this" {
  count = var.create_usage_plan ? 1 : 0
  name  = "${var.environment}-${var.project}-usage-plan"

  dynamic "api_stages" {
    for_each = length(var.api_stages) == 0 ? [] : var.api_stages 
    # for_each = try(var.api_stages,[""])
    content {
      api_id = lookup(api_stages.value, "api_id",aws_api_gateway_rest_api.this[0].id)
      stage  = lookup(api_stages.value, "stage",aws_api_gateway_stage.this[0].stage_name)
      dynamic "throttle" {
        // for_each = length(lookup(api_stages.value, "throttle", "")) == 0 ? [] : lookup(api_stages.value, "throttle", "")
        for_each = lookup(api_stages.value, "throttle", [])
        content {
          burst_limit = lookup(throttle.value,"burst_limit", null)
          path        = lookup(throttle.value,"path", "")
          rate_limit  = lookup(throttle.value,"rate_limit", null)
        }
      }
    }
  }

  dynamic "quota_settings" {
    # for_each = var.quota_settings
    for_each = length(var.quota_settings) == 0 ? [] : var.quota_settings 
    content {
      # limit - (required) is a type of number
      limit = quota_settings.value["limit"]
      # offset - (optional) is a type of number
      offset = quota_settings.value["offset"]
      # period - (required) is a type of string
      period = quota_settings.value["period"]
    }
  }

  dynamic "throttle_settings" {
    # for_each = var.throttle_settings
    for_each = length(var.throttle_settings) == 0 ? [] : var.throttle_settings
    content {
      # burst_limit - (optional) is a type of number
      burst_limit = throttle_settings.value["burst_limit"]
      # rate_limit - (optional) is a type of number
      rate_limit = throttle_settings.value["rate_limit"]
    }
  }
  # depends_on = [
  #   aws_api_gateway_stage.this
  # ]
}

resource "aws_api_gateway_api_key" "this" {
  count = var.create_usage_plan && var.create_api_key ? 1 : 0
  name  = "${var.environment}-${var.project}-api-key"
}

resource "aws_api_gateway_usage_plan_key" "this" {
  count         = var.create_usage_plan && var.create_api_key ? 1 : 0
  key_id        = aws_api_gateway_api_key.this[0].id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.this[0].id
}
