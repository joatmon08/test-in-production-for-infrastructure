data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_ami" "ubuntu_bionic" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "example" {
  instance_type          = "t2.micro"
  ami                    = var.enable_new_ami ? data.aws_ami.ubuntu_bionic.id : data.aws_ami.ubuntu.id
  vpc_security_group_ids = [aws_security_group.instances.0.id]
  subnet_id              = aws_subnet.public.0.id
  tags = {
    Terraform  = "true"
    Owner      = var.owner
    Has_Toggle = var.enable_new_ami
  }
}

resource "aws_instance" "example_bionic" {
  count                  = var.enable_new_ami ? 1 : 0
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.ubuntu_bionic.id
  vpc_security_group_ids = [aws_security_group.instances.0.id]
  subnet_id              = aws_subnet.public.0.id
  tags = {
    Terraform  = "true"
    Owner      = var.owner
    Has_Toggle = var.enable_new_ami
  }
}

