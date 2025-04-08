
output "cluster_name" {
  description = "The name of the EKS cluster."
  value       = module.eks.cluster_name
}

output "efs_id" {
  description = "The ID of the EFS file system."
  value       = module.efs.efs_id
}

output "certificate_arn" {
  value = module.acm.certificate_arn
}
