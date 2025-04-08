output "cluster_name" {
  description = "The name of the EKS cluster."
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "The endpoint of the EKS cluster."
  value       = module.eks.cluster_endpoint
}

output "cluster_version" {
  description = "The version of the EKS cluster."
  value       = module.eks.cluster_version
}
output "cluster_certificate_authority_data" {
  description = "The base64 encoded certificate data required to communicate with the EKS cluster."
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_oidc_issuer_url" {
  value = module.eks.oidc_provider
}