data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public" {
  count                   = var.enable_new_network ? 2 : 1
  vpc_id                  = aws_vpc.app_vpc[count.index].id
  cidr_block              = count.index == 0 ? var.vpc_cidr : cidrsubnet(var.vpc_cidr, 4, 0)
  availability_zone       = data.aws_availability_zones.available.names.0
  map_public_ip_on_launch = true

  tags = {
    Name      = "${var.prefix}-${count.index}-public-subnet"
    Owner     = var.owner
    Terraform = "true"
  }
}

