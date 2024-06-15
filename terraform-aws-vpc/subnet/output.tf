# output "subnets" {
#   value = [
#     for this in aws_subnet.this : this.id
#   ]
# }
output "subnets" {
  value = aws_subnet.this
}