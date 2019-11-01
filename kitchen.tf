resource "local_file" "kitchen" {
  count    = var.enable_new_network ? 1 : 0
  content  = templatefile("templates/kitchen.tpl", { canary = aws_instance.canary[count.index].private_ip, region = var.region, availability_zone = data.aws_availability_zones.available.names[0], public_subnet_id = aws_subnet.public[1].id, ami_id = data.aws_ami.ubuntu.id })
  filename = ".kitchen.yml"
}

resource "local_file" "canary_test" {
  count    = var.enable_new_network ? 1 : 0
  content  = templatefile("templates/canary_test.tpl", { canary = aws_instance.canary[count.index].private_ip })
  filename = "test/integration/default/controls/canary_test.rb"
}