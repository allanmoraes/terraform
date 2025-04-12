# Variáveis de projeto
variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
}

variable "owner" {
  description = "Proprietário responsável pelo recurso"
  type        = string
}

variable "git_repo" {
  description = "URL do repositório Git"
  type        = string
}

variable "cost_center" {
  description = "Centro de custo para faturamento"
  type        = string
}

# Variáveis de região
variable "aws_region" {
  description = "Região AWS para criar os recursos"
  type        = string
  default     = "us-east-1"
}

# Variáveis de rede
variable "vpc_cidr" {
  description = "CIDR block para a VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Lista de zonas de disponibilidade para usar"
  type        = list(string)
  default     = []
}

variable "public_subnet_cidrs" {
  description = "Lista de CIDRs para sub-redes públicas"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Lista de CIDRs para sub-redes privadas"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
}