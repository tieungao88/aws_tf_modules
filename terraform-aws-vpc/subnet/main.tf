locals {
  create_vpc = var.create_vpc
}

resource "aws_subnet" "this" {
  #for_each = var.prefix

  vpc_id                          = var.vpc_id
  cidr_block                      = var.cidr_block #each.value["cidr"]
  availability_zone_id            = var.availability_zone_id #each.value["az"]
  tags = merge(
    var.additional_tags,
    {
      "Name" = "${var.subnet_env}.${var.subnet_suffix}-${var.availability_zone_id}.subnet"
    },
  )
}