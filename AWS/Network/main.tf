provider "aws" {
  region = local.context[terraform.workspace].aws_region
}

data "aws_availability_zones" "available" {
    all_availability_zones = true
}

# Recuperar as zonas de disponibilidade disponíveis se não forem especificadas
locals {
  availability_zones = data.aws_availability_zones.available[*].names
  
  common_tags = {
    Name           = "${local.context[terraform.workspace].project_name}-${local.context[terraform.workspace].environment}"
    Environment    = local.context[terraform.workspace].environment
    Owner          = local.context[terraform.workspace].owner
    CostCenter     = local.context[terraform.workspace].cost_center
    GitRepo        = local.context[terraform.workspace].git_repo
    ManagedBy      = "terraform"
    IsTerrraformed = "true"
  }
}

# VPC
module "vpc" {
  source     = "./modules/vpc"
  cidr_block = local.context[terraform.workspace].vpc_cidr
  tags       = merge(local.common_tags, {
    Name = "${local.context[terraform.workspace].project_name}-vpc-${local.context[terraform.workspace].environment}"
  })
}

# Sub-redes públicas
module "public_subnets" {
  source             = "./modules/subnets"
  vpc_id             = module.vpc.vpc_id
  subnet_cidrs       = local.context[terraform.workspace].public_subnet_cidrs
  availability_zones = local.availability_zones
  is_public          = true
  tags               = merge(local.common_tags, {
    Name = "${local.context[terraform.workspace].project_name}-public-subnet-${local.context[terraform.workspace].environment}"
    Tier = "public"
  })
}

# Sub-redes privadas
module "private_subnets" {
  source             = "./modules/subnets"
  vpc_id             = module.vpc.vpc_id
  subnet_cidrs       = local.context[terraform.workspace].private_subnet_cidrs
  availability_zones = local.availability_zones
  is_public          = false
  tags               = merge(local.common_tags, {
    Name = "${local.context[terraform.workspace].project_name}-private-subnet-${local.context[terraform.workspace].environment}"
    Tier = "private"
  })
}

# Internet Gateway
module "internet_gateway" {
  source = "./modules/internet_gateway"
  vpc_id = module.vpc.vpc_id
  tags   = merge(local.common_tags, {
    Name = "${local.context[terraform.workspace].project_name}-igw-${local.context[terraform.workspace].environment}"
  })
}

# NAT Gateways - um em cada sub-rede pública
module "nat_gateways" {
  source            = "./modules/nat_gateway"
  count             = length(local.availability_zones)
  subnet_id         = element(module.public_subnets.subnet_ids, count.index)
  connectivity_type = local.context[terraform.workspace].environment == "prod" ? "public" : "private"
  tags              = merge(local.common_tags, {
    Name = "${local.context[terraform.workspace].project_name}-natgw-${count.index + 1}-${local.context[terraform.workspace].environment}"
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
    Name = "${local.context[terraform.workspace].project_name}-public-rt-${local.context[terraform.workspace].environment}"
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
    Name = "${local.context[terraform.workspace].project_name}-private-rt-${count.index + 1}-${local.context[terraform.workspace].environment}"
  })
}

# Grupos de segurança padrão
module "security_groups" {
  source      = "./modules/security_groups"
  vpc_id      = module.vpc.vpc_id
  environment = local.context[terraform.workspace].environment
  tags        = merge(local.common_tags, {
    Name = "${local.context[terraform.workspace].project_name}-sg-${local.context[terraform.workspace].environment}"
  })
}
