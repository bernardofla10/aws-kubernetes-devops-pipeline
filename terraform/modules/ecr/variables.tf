variable "repository_name" {
  type = string
}

variable "force_delete" {
  type    = bool
  default = false
}

variable "scan_on_push" {
  type    = bool
  default = true
}

variable "kms_key_arn" {
  type    = string
  default = null
}

variable "max_images" {
  type    = number
  default = 30
}

variable "untagged_expiration_days" {
  type    = number
  default = 1
}

variable "tags" {
  type    = map(string)
  default = {}
}