### Create SSM properties ###
resource "random_password" "password" {
  length           = var.length
  lower            = var.use_lower
  numeric          = var.use_number
  min_lower        = var.min_lower
  min_numeric      = var.min_numeric
  min_special      = var.min_special
  min_upper        = var.min_upper
  override_special = var.override_special == "" ? null : var.override_special
  special          = var.use_special
  upper            = var.use_upper

  keepers = {
    pass_version = var.pass_version
  }
}

resource "aws_secretsmanager_secret" "this" {
  name        = "${var.environment}-${var.account}-${var.project}-rds"
  description = "Secret with dynamically generated password."
  kms_key_id  = var.kms_key_arn
  tags = merge(
    {
      "Name" = "${var.environment}-${var.account}-${var.project}-rds-${var.engine}-db"
    },
    var.tags
  )
}

resource "aws_secretsmanager_secret_version" "version" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = <<EOF
   {
    "username": "${var.database_user}",
    "password": "${random_password.password.result}",
    "engine" : "${var.engine}",
    "port": "${var.database_port}",
    "dbInstanceIdentifier": "${var.environment}-${var.account}-${var.project}-rds-${var.engine}-db",
    "host": "${aws_db_instance.default.address}"
   }
EOF
}

### Create RDS instances ###

locals {
  computed_major_engine_version = var.engine == "mysql" ? join(".", slice(split(".", var.engine_version), 0, 1)) : join(".", slice(split(".", var.engine_version), 0, 2))
  major_engine_version          = var.major_engine_version == "" ? local.computed_major_engine_version : var.major_engine_version

  subnet_ids_provided           = var.subnet_ids != null && length(var.subnet_ids) > 0
  db_subnet_group_name_provided = var.db_subnet_group_name != null && var.db_subnet_group_name != ""

  db_subnet_group_name = local.db_subnet_group_name_provided ? var.db_subnet_group_name : (
    local.subnet_ids_provided ? join("", aws_db_subnet_group.default.*.name) : null
  )

  availability_zone = var.multi_az ? null : var.availability_zone

  log_type_postgres = var.engine == "postgres" ? ["postgresql", "upgrade"] : []
  log_type_mysql = var.engine == "mysql" ? ["audit", "error", "general", "slowquery"] : []
  log_type_mariadb = var.engine == "mariadb" ? ["audit", "error", "general", "slowquery"] : []
  log_type_mssql = var.engine == "mssql" ? ["agent" , "error"] : []
  log_type_oracle = var.engine == "oracle" ? ["alert", "audit", "listener", "trace"] : []

  license_model_postgres = var.engine == "postgres" ? "postgresql-license" : ""
  license_model_mysql = var.engine == "mysql" ? "general-public-license" : ""
  license_model_mariadb = var.engine == "mariadb" ? "general-public-license" : ""
  license_model_mssql = var.engine == "mssql" ? "license-included" : ""
  license_model_oracle = var.engine == "oracle" ? "license-included" : ""
}

resource "aws_db_instance" "default" {
  # count = module.this.enabled ? 1 : 0

  identifier            = "${var.environment}-${var.account}-${var.project}-rds-${var.engine}-db"
  # db_name               = "${var.environment}-${var.account}-${var.project}-db"
  username              = var.database_user
  password              = random_password.password.result
  port                  = var.database_port
  engine                = var.engine
  engine_version        = var.engine_version
  character_set_name    = var.charset_name
  instance_class        = var.instance_class
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_encrypted     = var.storage_encrypted
  kms_key_id            = var.kms_key_arn

  vpc_security_group_ids = compact(
    concat(
      [join("", aws_security_group.default.*.id)],
      var.associate_security_group_ids
    )
  )

  db_subnet_group_name = local.db_subnet_group_name
  availability_zone    = local.availability_zone

  ca_cert_identifier          = var.ca_cert_identifier
  # parameter_group_name        = length(var.parameter_group_name) > 0 ? var.parameter_group_name : join("", aws_db_parameter_group.default.*.name)
  # option_group_name           = length(var.option_group_name) > 0 ? var.option_group_name : join("", aws_db_option_group.default.*.name)
  parameter_group_name = aws_db_parameter_group.default.name
  # option_group_name = aws_db_option_group.default.*.name
  license_model               = coalesce(local.license_model_postgres, local.license_model_mysql, local.license_model_mariadb, local.license_model_mssql, local.license_model_oracle)
  multi_az                    = var.multi_az
  storage_type                = var.storage_type
  iops                        = var.iops
  publicly_accessible         = var.publicly_accessible
  snapshot_identifier         = var.snapshot_identifier
  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  apply_immediately           = var.apply_immediately
  maintenance_window          = var.maintenance_window
  skip_final_snapshot         = var.skip_final_snapshot
  copy_tags_to_snapshot       = var.copy_tags_to_snapshot
  backup_retention_period     = var.backup_retention_period
  backup_window               = var.backup_window
  tags = merge(
    {
      "Name" = "${var.environment}-${var.account}-${var.project}-rds-${var.engine}-db"
    },
    var.tags
  )
  deletion_protection         = var.deletion_protection
  # final_snapshot_identifier   = length(var.final_snapshot_identifier) > 0 ? var.final_snapshot_identifier : module.final_snapshot_label.id
  replicate_source_db         = var.replicate_source_db

  iam_database_authentication_enabled   = var.iam_database_authentication_enabled
  enabled_cloudwatch_logs_exports       = coalesce(local.log_type_postgres, local.log_type_mysql, local.log_type_mariadb, local.log_type_mssql, local.log_type_oracle)
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_kms_key_id       = var.performance_insights_enabled ? var.performance_insights_kms_key_id : null
  performance_insights_retention_period = var.performance_insights_enabled ? var.performance_insights_retention_period : null

  monitoring_interval = var.monitoring_interval
  monitoring_role_arn = var.monitoring_role_arn

  depends_on = [
    aws_db_subnet_group.default,
    aws_security_group.default,
    aws_db_parameter_group.default
    # aws_db_option_group.default
  ]

  lifecycle {
    ignore_changes = [
      snapshot_identifier, # if created from a snapshot, will be non-null at creation, but null afterwards
    ]
  }
}

resource "aws_db_parameter_group" "default" {
  # count = length(var.parameter_group_name) == 0 && module.this.enabled ? 1 : 0
  name  = "${var.environment}-${var.account}-${var.project}-${var.engine}-cluster-parameter-group"
  # name_prefix = "${module.this.id}${module.this.delimiter}"
  family = var.db_parameter_group
  tags = merge(
    {
      "Name" = "${var.environment}-${var.account}-${var.project}-${var.engine}-cluster-parameter-group"
    },
    var.tags
  )

  dynamic "parameter" {
    for_each = var.db_parameter
    content {
      apply_method = lookup(parameter.value, "apply_method", null)
      name         = parameter.value.name
      value        = parameter.value.value
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# resource "aws_db_option_group" "default" {
#   count = length(var.option_group_name) == 0 ? 1 : 0
#   name  = "${var.environment}-${var.account}-${var.project}-rds"
#   # name_prefix          = "${module.this.id}${module.this.delimiter}"
#   engine_name          = var.engine
#   major_engine_version = local.major_engine_version
#   tags = merge(
#     {
#       "Name" = "${var.environment}-${var.account}-${var.project}-optiongroup"
#     },
#     var.tags
#   )

#   dynamic "option" {
#     for_each = var.db_options
#     content {
#       db_security_group_memberships  = lookup(option.value, "db_security_group_memberships", null)
#       option_name                    = option.value.option_name
#       port                           = lookup(option.value, "port", null)
#       version                        = lookup(option.value, "version", null)
#       vpc_security_group_memberships = lookup(option.value, "vpc_security_group_memberships", null)

#       dynamic "option_settings" {
#         for_each = lookup(option.value, "option_settings", [])
#         content {
#           name  = option_settings.value.name
#           value = option_settings.value.value
#         }
#       }
#     }
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }

resource "aws_db_subnet_group" "default" {
  count = local.subnet_ids_provided && !local.db_subnet_group_name_provided ? 1 : 0

  name       = "${var.environment}-${var.account}-${var.project}-${var.engine}-subnetgroup"
  subnet_ids = var.subnet_ids
  tags = merge(
    {
      "Name" = "${var.environment}-${var.account}-${var.project}-${var.engine}-subnetgroup"
    },
    var.tags
  )
}

### Create Security group for RDS ###
resource "aws_security_group" "default" {
  name        = "${var.environment}-${var.account}-${var.project}-rds-sg"
  description = "Allow inbound traffic from the security groups"
  vpc_id      = var.vpc_id
  tags = merge(
    {
      "Name" = "${var.environment}-${var.account}-${var.project}-rds-sg"
    },
    var.tags
  )
}

resource "aws_security_group_rule" "ingress_security_groups" {
  count = length(var.security_group_ids) > 0 ? length(var.security_group_ids) : 0

  description              = "Allow inbound traffic from existing Security Groups"
  type                     = "ingress"
  from_port                = var.database_port
  to_port                  = var.database_port
  protocol                 = "tcp"
  source_security_group_id = var.security_group_ids[count.index]
  security_group_id        = aws_security_group.default.id
}

resource "aws_security_group_rule" "ingress_cidr_blocks" {
  count = length(var.allowed_cidr_blocks) > 0 ? 1 : 0

  description       = "Allow inbound traffic from CIDR blocks"
  type              = "ingress"
  from_port         = var.database_port
  to_port           = var.database_port
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "egress" {
  description       = "Allow all egress traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}
