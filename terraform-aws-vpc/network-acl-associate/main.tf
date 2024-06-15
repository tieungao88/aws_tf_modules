resource "aws_network_acl_association" "main" {
  network_acl_id = var.network_acl_id
  subnet_id      = var.subnet_id
}