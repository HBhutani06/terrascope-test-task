variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}
variable "cluster_endpoint" {
  description = "The endpoint of the EKS cluster."
  type        = string
}
variable "cluster_ca" {
  description = "The base64 encoded certificate data required to communicate with the EKS cluster."
  type        = string
}

variable "aws_region" {
  description = "The AWS region where the EKS cluster is located."
  type        = string
  
}