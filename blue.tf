data "aws_ami" "nginx" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-nginx-1.14*"]
  }

  owners = ["979382823631"]
}

resource "aws_instance" "application" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.nginx.id
  vpc_security_group_ids = [aws_security_group.instances.0.id]
  subnet_id              = aws_subnet.public.0.id
  tags = {
    Name  = "${var.prefix}-application"
    Owner = var.owner
  }
}

resource "aws_elb" "application" {
  name    = "${var.prefix}-elb"
  subnets = [aws_subnet.public.0.id]

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

  instances = [aws_instance.application.id]

  tags = {
    Owner = var.owner
  }
}

resource "aws_route53_record" "application" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "application.${aws_route53_zone.private.name}"
  type    = "A"

  alias {
    name                   = aws_elb.application.dns_name
    zone_id                = aws_elb.application.zone_id
    evaluate_target_health = true
  }

  weighted_routing_policy {
    weight = 10
  }

  set_identifier = "blue"
}