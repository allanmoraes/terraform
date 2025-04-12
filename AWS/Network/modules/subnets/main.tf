resource "aws_subnet" "this" {
  count                   = length(var.subnet_cidrs)
  vpc_id                  = var.vpc_id
  cidr_block              = element(var.subnet_cidrs, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = var.is_public
  
  # Mesclar as tags padrão com uma tag de nome dinâmica baseada no índice
  tags = merge(
    var.tags,
    {
      "Name" = format(
        "%s-%s",
        lookup(var.tags, "Name", "subnet"),
        element(var.availability_zones, count.index)
      )
    }
  )
}
