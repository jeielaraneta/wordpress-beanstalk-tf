data "aws_route53_zone" "ccst" {
  name = "ccst.com.au"
}

resource "aws_route53_record" "route53_record" {
  zone_id = data.aws_route53_zone.ccst.zone_id
  name    = var.record_name
  type    = "A"

  alias {
    name                   = var.eb_env.cname
    zone_id                = var.eb_hosted_zone.id
    evaluate_target_health = true
  }
}