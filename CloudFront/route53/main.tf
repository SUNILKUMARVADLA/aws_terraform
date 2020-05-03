
resource "aws_route53_zone" "zone" {
  name = var.root_domain_name
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = var.domain_name
  type    = "A"
  alias  {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "cert_validation" {
  name    = var.cert_name
  type    = var.cert_type
  zone_id = aws_route53_zone.zone.id
  records = [var.cert_value]
  ttl     = 60
}


resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = var.cert_arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}