variable "vpc_id" {
  description = "ID da VPC onde a tabela de rotas será criada"
  type        = string
}

variable "subnet_ids" {
  description = "Lista de IDs de sub-rede para associar à tabela de rotas"
  type        = list(string)
}

variable "gateway_id" {
  description = "ID do Internet Gateway para rotas públicas"
  type        = string
  default     = ""
}

variable "nat_gateway_id" {
  description = "ID do NAT Gateway para rotas privadas"
  type        = string
  default     = ""
}

variable "destination_cidr" {
  description = "CIDR de destino para a rota padrão (geralmente 0.0.0.0/0)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "route_type" {
  description = "Tipo de rota: public ou private"
  type        = string
}

variable "tags" {
  description = "Tags para a tabela de rotas"
  type        = map(string)
}
