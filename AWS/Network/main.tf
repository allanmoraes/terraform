resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
 
    tags = merge({
        Name = "${terraform.workspace}"
        }, local.labels)
}

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main.id

    tags = merge({
        Name = "${terraform.workspace}-internet-gateway"
        }, local.labels)
}

resource "aws_eip" "nat_eip" {
    domain        = "vpc"
    depends_on    = [aws_internet_gateway.gw]

    tags = merge({
        Name = "${terraform.workspace}-elastic-ip"
        }, local.labels)
}

resource "aws_nat_gateway" "nat_gw" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id     = element(aws_subnet.public_subnets.*.id, 0)

    tags = merge({
        Name = "${terraform.workspace}-nat-gateway"
        }, local.labels)
}

resource "aws_subnet" "public_subnets" {
    count                   = length(var.public_subnet_cidrs)
    vpc_id                  = aws_vpc.main.id
    cidr_block              = element(var.public_subnet_cidrs, count.index)
    availability_zone       = element(var.aws_az, count.index)
    map_public_ip_on_launch = true

    tags = merge({
        Name = "${terraform.workspace}-public-subnet-${element(var.aws_az, count.index)}"
        }, local.labels)
}
 
resource "aws_subnet" "private_subnets" {
    count                   = length(var.private_subnet_cidrs)
    vpc_id                  = aws_vpc.main.id
    cidr_block              = element(var.private_subnet_cidrs, count.index)
    availability_zone       = element(var.aws_az, count.index)
    map_public_ip_on_launch = false
    
    
    tags = merge({
        Name = "${terraform.workspace}-private-subnet-${element(var.aws_az, count.index)}"
        },  local.labels)
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id

    tags = merge({
        Name = "${terraform.workspace}-private-route-table"
        },  local.labels)
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    tags = merge({
        Name = "${terraform.workspace}-public-route-table"
        },  local.labels)
}

resource "aws_route" "public_internet_gateway" {
    route_table_id         = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route" "private_nat_gateway" {
    route_table_id         = aws_route_table.private.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

resource "aws_route_table_association" "public" {
    count          = length(var.public_subnet_cidrs)
    subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
    count          = length(var.private_subnet_cidrs)
    subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
    route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "default" {
    name        = "${terraform.workspace}-default-sg"
    description = "Default SG to allow traffic from the VPC"
    vpc_id      = aws_vpc.main.id
    depends_on = [
        aws_vpc.main
    ]   
        ingress {
            from_port = "0"
            to_port   = "0"
            protocol  = "-1"
            self      = true
        }   
        egress {
            from_port = "0"
            to_port   = "0"
            protocol  = "-1"
            self      = true
        }

    tags = local.labels
}