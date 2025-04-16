resource "helm_release" "aws_lb_controller" { # Deploy the AWS Load Balancer Controller using Helm
  name       = "aws-load-balancer-controller" # Name of the Helm release
  repository = "https://aws.github.io/eks-charts" # Helm chart repository for AWS EKS
  chart      = "aws-load-balancer-controller"    # Name of the Helm chart
  namespace  = "kube-system"                     # Namespace for the release

  set {
    name  = "clusterName"         # Name of the EKS cluster
    value = var.cluster_name       # Cluster name
  }

  set {
    name  = "serviceAccount.create" # Create a service account for the controller
    value = "true"
  }

  set {
    name  = "region"
    value = var.aws_region # AWS region for the controller
  }
}

# resource "null_resource" "apply_ingress" {
#   provisioner "local-exec" {
#     command = "kubectl apply -f ingress.yaml"
#   }

#   depends_on = [helm_release.aws_lb_controller]
# }
