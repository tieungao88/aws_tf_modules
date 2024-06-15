variable "subnet_ids" {
  type = list(string)
}
variable "transit_gateway_id" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "tgw_attachment" {
  type = string
}
variable "appliance_mode_support" {
  type = string
  default = "disable"
}