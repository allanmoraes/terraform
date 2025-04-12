output "subnet_ids" {
  description = "IDs das sub-redes criadas"
  value       = aws_subnet.this.*.id
}

output "subnet_arns" {
  description = "ARNs das sub-redes criadas"
  value       = aws_subnet.this.*.arn
}

output "subnet_cidrs" {
  description = "CIDRs das sub-redes criadas"
  value       = aws_subnet.this.*.cidr_block
}
