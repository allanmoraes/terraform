provider "aws" {
  region = var.aws_region
}

# Recuperar as zonas de disponibilidade disponíveis se não forem especificadas
locals {
  availability_zones = length(var.availability_zones) > 0 ? var.availability_zones : slice(data.aws_availability_zones.available.names, 0, 3)
  
  common_tags = {
    Name           = "${var.project_name}-${var.environment}"
    Environment    = var.environment
    Owner          = var.owner
    CostCenter     = var.cost_center
    GitRepo        = var.git_repo
    ManagedBy      = "terraform"
    IsTerrraformed = "true"
  }
}

data "aws_availability_zones" "available" {}

# VPC
module "vpc" {
  source     = "./modules/vpc"
  cidr_block = var.vpc_cidr
  tags       = merge(local.common_tags, {
    Name = "${var.project_name}-vpc-${var.environment}"
  })
}

# Sub-redes públicas
module "public_subnets" {
  source             = "./modules/subnets"
  vpc_id             = module.vpc.vpc_id
  subnet_cidrs       = var.public_subnet_cidrs
  availability_zones = local.availability_zones
  is_public          = true
  tags               = merge(local.common_tags, {
    Name = "${var.project_name}-public-subnet-${var.environment}"
    Tier = "public"
  })
}

# Sub-redes privadas
module "private_subnets" {
  source             = "./modules/subnets"
  vpc_id             = module.vpc.vpc_id
  subnet_cidrs       = var.private_subnet_cidrs
  availability_zones = local.availability_zones
  is_public          = false
  tags               = merge(local.common_tags, {
    Name = "${var.project_name}-private-subnet-${var.environment}"
    Tier = "private"
  })
}

# Internet Gateway
module "internet_gateway" {
  source = "./modules/internet_gateway"
  vpc_id = module.vpc.vpc_id
  tags   = merge(local.common_tags, {
    Name = "${var.project_name}-igw-${var.environment}"
  })
}

# NAT Gateways - um em cada sub-rede pública
module "nat_gateways" {
  source            = "./modules/nat_gateway"
  count             = length(local.availability_zones)
  subnet_id         = element(module.public_subnets.subnet_ids, count.index)
  connectivity_type = var.environment == "prod" ? "public" : "private"
  tags              = merge(local.common_tags, {
    Name = "${var.project_name}-natgw-${count.index + 1}-${var.environment}"
  })
}

# Tabela de rotas pública
module "public_route_tables" {
  source           = "./modules/route_tables"
  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.public_subnets.subnet_ids
  gateway_id       = module.internet_gateway.gateway_id
  destination_cidr = "0.0.0.0/0"
  route_type       = "public"
  tags             = merge(local.common_tags, {
    Name = "${var.project_name}-public-rt-${var.environment}"
  })
}

# Tabelas de rotas privadas - uma para cada AZ
module "private_route_tables" {
  source            = "./modules/route_tables"
  count             = length(local.availability_zones)
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = [element(module.private_subnets.subnet_ids, count.index)]
  nat_gateway_id    = element(module.nat_gateways.*.nat_gateway_id, count.index)
  destination_cidr  = "0.0.0.0/0"
  route_type        = "private"
  tags              = merge(local.common_tags, {
    Name = "${var.project_name}-private-rt-${count.index + 1}-${var.environment}"
  })
}

# Grupos de segurança padrão
module "security_groups" {
  source      = "./modules/security_groups"
  vpc_id      = module.vpc.vpc_id
  environment = var.environment
  tags        = merge(local.common_tags, {
    Name = "${var.project_name}-sg-${var.environment}"
  })
}
