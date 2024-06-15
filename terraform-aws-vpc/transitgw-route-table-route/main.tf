resource "aws_ec2_transit_gateway_route" "tgw_route_table_route" {
  destination_cidr_block         = var.destination_cidr
  transit_gateway_attachment_id  = var.transit_gateway_attachment_id
  transit_gateway_route_table_id = var.tgw_route_table
}