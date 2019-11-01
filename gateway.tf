resource "aws_internet_gateway" "app_vpc" {
  count  = var.enable_new_network ? 2 : 1
  vpc_id = aws_vpc.app_vpc[count.index].id
  tags = {
    Name      = "${var.prefix}-${count.index}-gateway"
    Owner     = var.owner
    Terraform = "true"
  }
}

resource "aws_route_table" "public" {
  count  = var.enable_new_network ? 2 : 1
  vpc_id = aws_vpc.app_vpc[count.index].id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_vpc[count.index].id
  }
  tags = {
    Name      = "${var.prefix}-${count.index}-public-route"
    Owner     = var.owner
    Terraform = "true"
  }
}

resource "aws_route_table_association" "public" {
  count          = var.enable_new_network ? 2 : 1
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}