variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}
variable "enable_ipv6" {
  description = "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block."
  type        = bool
  default     = false
}

variable "private_subnet_ipv6_prefixes" {
  description = "Assigns IPv6 private subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list"
  type        = list(string)
  default     = []
}

variable "public_subnet_ipv6_prefixes" {
  description = "Assigns IPv6 public subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list"
  type        = list(string)
  default     = []
}
variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}
variable "vpc_id" {
  description = "A list of availability zones names or ids in the region"
  type        = string
  default     = ""
}
variable "cidr_block" {
  description = "A list of availability zones names or ids in the region"
  type        = string
  default     = ""
}
variable "availability_zone_id" {
  description = "A list of availability zones names or ids in the region"
  type        = string
  default     = ""
}
variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  type        = bool
  default     = true
}
variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}
variable "subnet_env" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}
variable "subnet_suffix" {
  description = "Suffix to append to private subnets name"
  type        = string
  default     = ""
}

variable "prefix" {
   type = map
}
variable "additional_tags" {
   type = map(any)
}