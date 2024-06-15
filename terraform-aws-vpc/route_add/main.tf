# resource "aws_route" "this" {
#   count = var.routeover == "tgw" ? 1 : 0
#   route_table_id     = var.route_table_id
#   nat_gateway_id = var.target_id
#   # vpc_endpoint_id    = var.vpc_endpoint_id
#   depends_on         = [var.aws_route_table]
#   destination_cidr_block = var.destination_cidr_block
# }
# resource "aws_route" "vpce" {
#   count = var.routeover == "vpce" ? 1 : 0
#   route_table_id     = var.route_table_id
#   # transit_gateway_id = var.transit_gateway_id
#   vpc_endpoint_id    = var.target_id
#   depends_on         = [var.aws_route_table]
#   destination_cidr_block = var.destination_cidr_block
# }
# resource "aws_route" "natgw" {
#   count = var.routeover == "natgw" ? 1 : 0
#   route_table_id     = var.route_table_id
#   # transit_gateway_id = var.transit_gateway_id
#   gateway_id    = var.target_id
#   depends_on         = [var.aws_route_table]
#   destination_cidr_block = var.destination_cidr_block
# }

# resource "aws_route" "other" {
#   count = var.routeover == "endpoint" ? 1 : 0
#   route_table_id     = var.route_table_id
#   transit_gateway_id = var.target_id
#   depends_on         = [var.aws_route_table]
#   destination_cidr_block = var.destination_cidr_block
# }

resource "aws_route" "overtgw" {
  count = var.routeover == "tgw" ? 1 : 0
  route_table_id     = var.route_table_id
  transit_gateway_id = var.target_id
  depends_on         = [var.aws_route_table]
  destination_cidr_block = var.destination_cidr_block
}
resource "aws_route" "overvpce" {
  count = var.routeover == "vpce" ? 1 : 0
  route_table_id     = var.route_table_id
  vpc_endpoint_id    = var.target_id
  depends_on         = [var.aws_route_table]
  destination_cidr_block = var.destination_cidr_block
}
resource "aws_route" "overigw" {
  count = var.routeover == "igw" ? 1 : 0
  route_table_id     = var.route_table_id
  gateway_id    = var.target_id
  depends_on         = [var.aws_route_table]
  destination_cidr_block = var.destination_cidr_block
}

resource "aws_route" "overnatgw" {
  count = var.routeover == "natgw" ? 1 : 0
  route_table_id     = var.route_table_id
  nat_gateway_id = var.target_id
  depends_on         = [var.aws_route_table]
  destination_cidr_block = var.destination_cidr_block
}