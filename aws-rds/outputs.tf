output "rds_arn" {
  description = "ARN of the rds instance created"
  value = aws_db_instance.default.arn
}

output "rds_host" {
  description = "Host of the rds instance created"
  value = aws_db_instance.default.address
}

output "rds_securitygroup" {
  description = "Name of rds's security group created"
  value = aws_security_group.default.name
}

output "secretmanager_arn" {
  description = "ARN of the secretmanager created"
  value = aws_secretsmanager_secret.this.arn
}