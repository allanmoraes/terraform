variable "vpc_id" {
  description = "ID da VPC onde o Internet Gateway será criado"
  type        = string
}

variable "tags" {
  description = "Tags para o Internet Gateway"
  type        = map(string)
}
