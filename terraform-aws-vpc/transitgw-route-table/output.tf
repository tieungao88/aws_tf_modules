output "transitgw_route_tbl_id" {
  value = try(aws_ec2_transit_gateway_route_table.this.id, "")
}