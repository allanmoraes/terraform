resource "aws_eip" "this" {
  domain  = "vpc"
  tags = var.tags
}

resource "aws_nat_gateway" "this" {
  allocation_id     = aws_eip.this.id
  subnet_id         = var.subnet_id
  connectivity_type = var.connectivity_type
  tags              = var.tags
}
