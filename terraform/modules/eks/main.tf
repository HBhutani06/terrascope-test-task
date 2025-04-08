module "eks" {
  source  = "terraform-aws-modules/eks/aws" # Source of the EKS module from the Terraform Registry
  version = "~> 20.0"

  cluster_name                   = var.cluster_name    # Name of the EKS cluster
  cluster_version                = var.cluster_version # Version of the EKS cluster
  cluster_endpoint_public_access = true                # Enable public access to the cluster endpoint

  #CLUSTER ADDONS
  cluster_addons = {
    coredns    = { most_recent = true } # CoreDNS addon for DNS resolution
    kube-proxy = { most_recent = true } # Kube-proxy addon for network routing

    #EKS Pod Identity Agent Policy
    eks-pod-identity-agent = {
      most_recent = true
      iam_role_additional_policies = [
        "arn:aws:iam::aws:policy/AmazonEKS_PodIdentityAgentPolicy"
      ]
    }
    # Allows access to VPC CNI
    vpc-cni = {
      most_recent = true
      iam_role_additional_policies = [
        "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
      ]
    }
    # Allows access to Amazon EFS
    aws-efs-csi-driver = {
      most_recent = true
      iam_role_additional_policies = [
        "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
      ]
    }
    metrics-server = { most_recent = true } # Metrics server for resource metrics


  }

  vpc_id                   = var.vpc_id         # Attach the EKS cluster to the VPC
  control_plane_subnet_ids = var.public_subnets #Deploys EKS control plane in public subnets 
  subnet_ids               = var.subnet_ids     #Deploys EKS worker nodes in private subnets

  eks_managed_node_groups = {
    image-api-nodegroup = {
      min_size       = var.min_size       #Minimum number of worker nodes
      max_size       = var.max_size       #Maximum number of worker nodes
      desired_size   = var.desired_size   #Desired number of worker nodes
      instance_types = var.instance_types #Instance types for the worker nodes
      ami_type       = var.ami_type       #AMI type for the node

      labels = {
        nodegroup = var.node_group_label #Label for the node group
      }
    }
  }

  enable_cluster_creator_admin_permissions = true # Grant admin permissions to the cluster creator

  tags = {
    Environment = var.environment # Tag for the environment
    Terraform   = "true"
  }
}
