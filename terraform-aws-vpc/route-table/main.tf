resource "aws_route_table" "this" {
  vpc_id = var.vpc_id

#   route {
#     cidr_block = "10.0.1.0/24"
#     gateway_id = aws_internet_gateway.example.id
#   }
  tags = {
    Name = "${var.route_table_name}"
  }
}