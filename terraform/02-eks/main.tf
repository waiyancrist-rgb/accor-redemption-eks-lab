module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 20.0"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = data.terraform_remote_state.network.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.network.outputs.private_subnet_ids

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true
  enable_irsa                     = true

  # Native KMS cluster secrets envelope encryption using the key from 01-infra
  cluster_encryption_config = {
    resources        = ["secrets"]
    provider_key_arn = data.terraform_remote_state.infra.outputs.kms_key_arn
  }

  cluster_addons = {
    coredns                = {}
    kube-proxy             = {}
    vpc-cni                = {}
    eks-pod-identity-agent = {}
  }

  eks_managed_node_groups = {
    system = {
      name           = "system-ng"
      instance_types = ["t3.medium"]
      min_size       = 2
      max_size       = 5
      desired_size   = 2
      subnet_ids     = data.terraform_remote_state.network.outputs.private_subnet_ids
      labels = {
        workload = "system"
      }
    }
    application = {
      name           = "app-ng"
      instance_types = ["m6i.large", "m6a.large"]
      min_size       = 2
      max_size       = 16
      desired_size   = 3
      subnet_ids     = data.terraform_remote_state.network.outputs.private_subnet_ids
      labels = {
        workload = "application"
      }
    }
  }

  tags = var.tags
}