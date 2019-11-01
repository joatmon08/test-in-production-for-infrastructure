resource "aws_vpc" "app_vpc" {
  count      = var.enable_new_network ? 2 : 1
  cidr_block = var.vpc_cidr

  tags = {
    Name      = "${var.prefix}-${count.index}"
    Owner     = var.owner
    Terraform = "true"
  }
}

