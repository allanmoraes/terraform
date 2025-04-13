output "vpc_id" {
  description = "ID da VPC criada"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "CIDR da VPC"
  value       = local.context[terraform.workspace].vpc_cidr
}

output "public_subnet_ids" {
  description = "IDs das sub-redes públicas"
  value       = module.public_subnets.subnet_ids
}

output "private_subnet_ids" {
  description = "IDs das sub-redes privadas"
  value       = module.private_subnets.subnet_ids
}

output "nat_gateway_ids" {
  description = "IDs dos NAT Gateways"
  value       = module.nat_gateways.*.nat_gateway_id
}

output "internet_gateway_id" {
  description = "ID do Internet Gateway"
  value       = module.internet_gateway.gateway_id
}

output "security_group_ids" {
  description = "IDs dos grupos de segurança"
  value       = module.security_groups.security_group_ids
}
