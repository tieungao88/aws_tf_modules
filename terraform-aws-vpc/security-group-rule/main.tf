resource "aws_security_group_rule" "sg-id" {
    count = var.sg_source == "sg-id" ? 1 : 0
    type              = var.type
    from_port         = var.from_port
    to_port           = var.to_port
    protocol          = var.protocol
    source_security_group_id = var.source_addr
    security_group_id = var.security_group_id
}
resource "aws_security_group_rule" "cidr" {
    count = var.sg_source == "cidr" ? 1 : 0
    type              = var.type
    from_port         = var.from_port
    to_port           = var.to_port
    protocol          = var.protocol
    cidr_blocks       = [var.source_addr]
    security_group_id = var.security_group_id
}
