resource "aws_network_acl_rule" "this" {
  network_acl_id = var.this_id
  rule_number    = var.this_rule_number
  egress         = var.this_egress
  protocol       = var.this_protocol
  rule_action    = var.this_rule_action
  cidr_block     = var.this_cidr_block
  from_port      = var.this_from_port
  to_port        = var.this_to_port
}
