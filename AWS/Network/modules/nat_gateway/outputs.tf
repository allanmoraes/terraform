output "nat_gateway_id" {
  description = "ID do NAT Gateway criado"
  value       = aws_nat_gateway.this.id
}

output "eip_id" {
  description = "ID do Elastic IP alocado para o NAT Gateway"
  value       = aws_eip.this.id
}

output "eip_public_ip" {
  description = "IP público do Elastic IP alocado para o NAT Gateway"
  value       = aws_eip.this.public_ip
}
