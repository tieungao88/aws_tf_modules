locals {
  enabled                = true
  create_rest_api_policy = local.enabled && var.rest_api_policy != null
  create_log_group       = local.enabled && var.logging_level != "OFF"
  log_group_arn          = local.create_log_group ? module.cloudwatch_log_group.log_group_arn : null
  # vpc_link_enabled       = local.enabled && length(var.vpclink_id) > 0
  vpc_endpoint_enabled = var.endpoint_type == "PRIVATE" ? true : false
}

# Create log group
module "cloudwatch_log_group" {
  source               = "cloudposse/cloudwatch-logs/aws"
  version              = "0.6.5"
  enabled              = local.create_log_group
  iam_tags_enabled     = var.iam_tags_enabled
  permissions_boundary = var.permissions_boundary
  retention_in_days    = var.retention_in_days
  name                 = var.endpoint_type == "PRIVATE" ? "${var.environment}-${var.account}-${var.project}-${var.name_prefix}-internal" : "${var.environment}-${var.account}-${var.project}-${var.name_prefix}-public"
  tags = merge(
    {
      "Name" = "${var.environment}-${var.account}-${var.project}-${var.name_prefix}-loggroup"
    },
    var.tags
  )
  # context = module.this.context
}