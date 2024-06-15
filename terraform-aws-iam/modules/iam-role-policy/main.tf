resource "aws_iam_role_policy" "inline_policy" {
  count = var.create_policy ? 1 : 0
  name = var.name
  role = var.role

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = var.policy
}