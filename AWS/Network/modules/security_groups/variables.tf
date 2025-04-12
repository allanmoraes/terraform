variable "vpc_id" {
  description = "ID da VPC onde os grupos de segurança serão criados"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
}

variable "tags" {
  description = "Tags para os grupos de segurança"
  type        = map(string)
}
