variable "vpc_id" {
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
variable "subnet_ids" {
  description = "subnet_ids"
  type        = string
  default     = ""
}
variable "acls" {
  type = list(string)
  default = ["alc1","acl2","acl3"]
}