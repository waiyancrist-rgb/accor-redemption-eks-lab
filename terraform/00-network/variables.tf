variable "region" {
  type        = string
  description = "The target AWS region for deployment"
  default     = "ap-southeast-1"
}

variable "name" {
  type        = string
  description = "Base name prefix for all network resources"
  default     = "accor-redemption-prod"
}

variable "vpc_cidr" {
  type        = string
  description = "The main CIDR block allocated for the VPC"
  default     = "10.0.0.0/16"
}

variable "azs" {
  type        = list(string)
  description = "Availability zones to provide high availability across infrastructure"
  default     = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
}

variable "public_subnets" {
  type        = list(string)
  description = "Subnets used for internet-facing resources like ALBs"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnets" {
  type        = list(string)
  description = "Subnets reserved for private compute nodes/EKS worker nodes"
  default     = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}

variable "database_subnets" {
  type        = list(string)
  description = "Subnets strictly reserved for isolated multi-AZ database backends"
  default     = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]
}

variable "cluster_name" {
  type        = string
  description = "The name of the target EKS cluster for discovery tags"
  default     = "redemption-prod"
}

variable "tags" {
  type        = map(string)
  description = "Standard corporate resource tracking tags"
  default = {
    Environment = "prod"
    Project     = "accor-redemption"
    ManagedBy   = "terraform"
  }
}