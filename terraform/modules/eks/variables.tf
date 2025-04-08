variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "cluster_version" {
  description = "The version of the EKS cluster."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where EKS will be deployed."
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs where EKS nodes will be deployed."
  type        = list(string)
}
variable "environment" {
  description = "The environment for the EKS cluster (e.g., dev, staging, prod)."
  type        = string
}

variable "min_size" {
  description = "Minimum node count in ASG"
  type        = number

}

variable "max_size" {
  description = "Maximum node count in ASG"
  type        = number

}

variable "desired_size" {
  description = "Desired node count in ASG"
  type        = number

}
variable "instance_types" {
  description = "Instance types for EKS nodes"
  type        = list(string)

}
variable "ami_type" {
  description = "AMI type for EKS nodes"
  type        = string
}
variable "public_subnets" {
  description = "A list of public subnet IDs."
  type        = list(string)
}
variable "node_group_label" {
  description = "The name of the node group."
  type        = string
}
