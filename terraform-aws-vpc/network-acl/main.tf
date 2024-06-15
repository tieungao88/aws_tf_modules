locals {
  create_vpc = var.create_vpc
}

resource "aws_network_acl" "this" {
  vpc_id = var.vpc_id
  tags = {
    "Name": "${var.subnet_env}.${var.name}.acl"
  }
}