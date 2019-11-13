resource "aws_route53_zone" "private" {
  name = "test.in.production"

  vpc {
    vpc_id = aws_vpc.app_vpc.0.id
  }
}