resource "aws_ecr_repository" "ecr_tmp" {
  name = var.ecr_name
  tags = var.tags
}
resource "aws_ecr_repository_policy" "ecr_tmp" {
  repository = var.ecr_name
  # policy     = jsonencode(var.ecr_policy.policy)
  policy = var.ecr_policy
}
