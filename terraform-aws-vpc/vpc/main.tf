locals {
  create_vpc = var.create_vpc
}
resource "aws_vpc" "this" {
  count = local.create_vpc ? 1 : 0
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "${var.vpc_name}"
  }
}