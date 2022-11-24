resource "aws_acm_certificate" "tlscert" {
  domain_name = var.domain
  subject_alternative_names = [var.subdomain]
  validation_method = "DNS"
  tags = {
    Environment = "Cloud resume prod"
  }
  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "primaryzone" {
  name = var.domain
  private_zone = false
}

resource "aws_route53_record" "validaterecord" {
  for_each = {
    for dvo in aws_acm_certificate.tlscert.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.primaryzone.zone_id
}

resource "aws_acm_certificate_validation" "tlscertvalidation" {
  certificate_arn         = aws_acm_certificate.tlscert.arn
  validation_record_fqdns = [for record in aws_route53_record.validaterecord : record.fqdn]
}