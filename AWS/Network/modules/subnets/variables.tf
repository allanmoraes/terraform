variable "vpc_id" {
  description = "ID da VPC onde as sub-redes serão criadas"
  type        = string
}

variable "subnet_cidrs" {
  description = "Lista de CIDRs de sub-rede"
  type        = list(string)
}

variable "availability_zones" {
  description = "Lista de zonas de disponibilidade onde criar as sub-redes"
  type        = list(string)
}

variable "is_public" {
  description = "Se a sub-rede deve ser pública (true) ou privada (false)"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags para as sub-redes"
  type        = map(string)
}
