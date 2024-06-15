variable "vpc_cidr" {
  type    = string
  default = ""
}
variable "vpc_name" {
  type    = string
  default = ""
}
variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  type        = bool
  default     = true
}