resource "aws_route_table" "this" {
  vpc_id = var.vpc_id
  tags   = var.tags
}

resource "aws_route" "public" {
  count                  = var.route_type == "public" ? 1 : 0
  route_table_id         = aws_route_table.this.id
  destination_cidr_block = var.destination_cidr
  gateway_id             = var.gateway_id
}

resource "aws_route" "private" {
  count                  = var.route_type == "private" ? 1 : 0
  route_table_id         = aws_route_table.this.id
  destination_cidr_block = var.destination_cidr
  nat_gateway_id         = var.nat_gateway_id
}

resource "aws_route_table_association" "this" {
  count          = length(var.subnet_ids)
  subnet_id      = element(var.subnet_ids, count.index)
  route_table_id = aws_route_table.this.id
}
