resource "aws_instance" "canary" {
  count                  = var.enable_new_network ? 1 : 0
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.ubuntu.id
  vpc_security_group_ids = [aws_security_group.instances[1].id]
  subnet_id              = aws_subnet.public[1].id
  tags = {
    Name  = "${var.prefix}-canary-${count.index}"
    Owner = var.owner
  }
}