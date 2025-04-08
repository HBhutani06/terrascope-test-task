module "vpc" {
  source = "terraform-aws-modules/vpc/aws" # Source of the VPC module from the Terraform Registry

  name = var.vpc_name # Name of the VPC
  cidr = var.vpc_cidr # CIDR block for the VPC


  azs             = var.azs             # Availability Zones for the VPC
  private_subnets = var.private_subnets # Private Subnets for the VPC
  public_subnets  = var.public_subnets  # Public Subnets for the VPC

  enable_nat_gateway = true # Enable NAT Gateway for private subnets
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"          # Tag for Terraform
    Environment = var.environment # Tag for the environment
  }
}
