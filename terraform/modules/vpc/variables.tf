variable "vpc_name" {
  description = "The name of the VPC."
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "azs" {
  description = "A list of availability zones for the VPC."
  type        = list(string)
}

variable "private_subnets" {
  description = "A list of CIDR blocks for private subnets."
  type        = list(string)
}

variable "public_subnets" {
  description = "A list of CIDR blocks for public subnets."
  type        = list(string)
}
variable "environment" {
  description = "The environment for the VPC (e.g., dev, staging, prod)."
  type        = string

}
