resource "aws_security_group" "instances" {
  count       = var.enable_new_network ? 2 : 1
  name        = "${var.prefix}-instances"
  description = "Security group for instances"
  vpc_id      = aws_vpc.app_vpc[count.index].id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Terraform = "true"
    Owner     = var.owner
  }
}

