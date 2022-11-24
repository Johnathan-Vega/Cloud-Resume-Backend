data "aws_route53_zone" "primaryzone" {
  name = var.domain
}

resource "aws_route53_record" "root_alias" {
  zone_id = data.aws_route53_zone.primaryzone.zone_id
  name = var.domain
  type = "A"

  alias {
    name = var.cloudfront_domain_name
    zone_id = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "sub-alias" {
  zone_id = data.aws_route53_zone.primaryzone.zone_id
  name = var.subdomain
  type = "A"

  alias {
    name = var.cloudfront_domain_name
    zone_id = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}