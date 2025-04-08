variable "vpc_id" {
  description = "The ID of the VPC where EFS will be deployed."
  type        = string
}
variable "subnet_ids" {}
variable "environment" {
  description = "The environment for the EFS cluster (e.g., dev, staging, prod)."
  type        = string
}

variable "efs_name" {
  description = "The name of the EFS file system."
  type        = string
}
variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = list(string)
}
