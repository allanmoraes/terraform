variable "cidr_block" {
  description = "CIDR block para a VPC"
  type        = string
}

variable "tags" {
  description = "Tags para a VPC"
  type        = map(string)
}
