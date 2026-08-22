variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "devops-eks-platform"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "github_subject_prefix" {
  description = "Immutable GitHub OIDC subject prefix"
  type        = string
}

variable "terraform_state_bucket_arn" {
  description = "ARN of the Terraform state S3 bucket"
  type        = string
}