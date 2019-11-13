data "aws_ami" "nginx_green" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-nginx-1.16*"]
  }

  owners = ["979382823631"]
}

resource "aws_instance" "application_green" {
  count                  = var.enable_green_application ? 1 : 0
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.nginx_green.id
  vpc_security_group_ids = aws_security_group.instances.*.id
  subnet_id              = aws_subnet.public.0.id
  tags = {
    Name       = "${var.prefix}-application"
    Has_Toggle = var.enable_green_application
    Owner      = var.owner
  }
}

resource "aws_elb" "application_green" {
  count   = var.enable_green_application ? 1 : 0
  name    = "${var.prefix}-green-elb"
  subnets = aws_subnet.public.*.id

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances = aws_instance.application_green.*.id

  tags = {
    Owner      = var.owner
    Has_Toggle = var.enable_green_application
  }
}

resource "aws_route53_record" "application_green" {
  count   = var.enable_green_application ? 1 : 0
  zone_id = aws_route53_zone.private.zone_id
  name    = "application.${aws_route53_zone.private.name}"
  type    = "A"

  alias {
    name                   = aws_elb.application_green.0.dns_name
    zone_id                = aws_elb.application_green.0.zone_id
    evaluate_target_health = true
  }

  weighted_routing_policy {
    weight = 0
  }

  set_identifier = "green"
}