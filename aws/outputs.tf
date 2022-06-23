output "region" {
  value       = var.aws_region
  description = "AWS Region"
}

output "kubernetes_cluster_name" {
  value       = module.eks.cluster_id
  description = "EKS Cluster Name"
}
