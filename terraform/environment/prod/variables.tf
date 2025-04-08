variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type        = string
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private Subnets"
  type        = list(string)
}

variable "public_subnets" {
  description = "Public Subnets"
  type        = list(string)
}

variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
}

variable "cluster_version" {
  description = "EKS Cluster Version"
  type        = string

}
variable "environment" {
  description = "Environment (e.g., dev, staging, prod)"
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

variable "node_group_label" {
  description = "The name of the node group."
  type        = string
}
variable "efs_name" {
  description = "Name of the EFS"
  type        = string
}
variable "vpc_cidr_block" {
  description = "VPC CIDR Block"
  type        = list(string)
}

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
}

variable "waf_name" {
  description = "Name of the WAF ACL"
  type        = string
}
variable "rate_limit" {
  description = "Rate limit (requests per 5 min)"
  type        = number
}
variable "prometheus_chart_name" {
  description = "Helm release name for Prometheus stack"
  type        = string
  default     = "kube-prometheus-stack"
}
variable "monitoring_namespace" {
  description = "Namespace for monitoring tools"
  type        = string
}
