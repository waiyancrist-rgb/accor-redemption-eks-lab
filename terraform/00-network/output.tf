output "vpc_id" {
  description = "The ID of the provisioned VPC core network framework"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of IDs corresponding to public subnets"
  value       = module.vpc.public_subnets
}

output "private_subnet_ids" {
  description = "List of IDs corresponding to private application subnets"
  value       = module.vpc.private_subnets
}

output "database_subnet_ids" {
  description = "List of IDs corresponding to private isolated database subnets"
  value       = module.vpc.database_subnets
}

output "azs" {
  description = "The list of Availability Zones utilized by the subnet arrays"
  value       = var.azs
}