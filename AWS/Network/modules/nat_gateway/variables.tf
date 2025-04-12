variable "subnet_id" {
  description = "ID da sub-rede onde o NAT Gateway será criado"
  type        = string
}

variable "connectivity_type" {
  description = "Tipo de conectividade do NAT Gateway: public ou private"
  type        = string
  default     = "public"
}

variable "tags" {
  description = "Tags para o NAT Gateway"
  type        = map(string)
}
