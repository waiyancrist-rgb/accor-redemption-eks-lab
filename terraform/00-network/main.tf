module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = var.name
  cidr = var.vpc_cidr

  azs              = var.azs
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  database_subnets = var.database_subnets

  # Core Gateway Configuration
  enable_nat_gateway = true
  single_nat_gateway = true
  
  # Core Internal Resolution
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Discovery Tags for AWS Load Balancer Controller (Public Subnets)
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  # Discovery Tags for Internal Load Balancers & Karpenter Provisioner Node Placements
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
    "karpenter.sh/discovery"          = var.cluster_name
  }

  tags = var.tags
}