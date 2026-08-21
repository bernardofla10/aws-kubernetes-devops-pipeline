variable "name" {
  description = "Base name for network resources"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid IPv4 CIDR."
  }
}

variable "public_subnets" {
  description = "Availability Zone -> public subnet CIDR"
  type        = map(string)
}

variable "private_subnets" {
  description = "Availability Zone -> private subnet CIDR"
  type        = map(string)
}

variable "single_nat_gateway" {
  description = "Use one NAT Gateway for all AZs"
  type        = bool
  default     = true
}

variable "tags" {
  type    = map(string)
  default = {}
}