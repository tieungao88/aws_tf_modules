variable "target_id" {
  type = string
}
variable "route_table_id" {
  type = string
}
variable "aws_route_table" {
  type = string
}
variable "destination_cidr_block" {
  type = string
}
variable "routeover" {
  type = string
  default = "tgw"
}