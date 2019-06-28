resource "aws_acm_certificate" "wildcard_cert" {
  domain_name       = "${var.name}-web.${var.route53_zone}"
  validation_method = "DNS"
}

data "aws_route53_zone" "wildcard_zone" {
  name         = "${var.route53_zone}"
  private_zone = false
}

resource "aws_route53_record" "wildcard_cert_validation" {
  depends_on = ["aws_acm_certificate.wildcard_cert"]
  name       = "${aws_acm_certificate.wildcard_cert.domain_validation_options.0.resource_record_name}"
  type       = "${aws_acm_certificate.wildcard_cert.domain_validation_options.0.resource_record_type}"
  zone_id    = "${data.aws_route53_zone.wildcard_zone.zone_id}"
  records    = ["${aws_acm_certificate.wildcard_cert.domain_validation_options.0.resource_record_value}"]
  ttl        = 60
}

resource "aws_acm_certificate_validation" "wildcard_cert" {
  certificate_arn         = "${aws_acm_certificate.wildcard_cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.wildcard_cert_validation.fqdn}"]
}

resource "aws_route53_record" "route" {
  zone_id = "${data.aws_route53_zone.wildcard_zone.zone_id}"
  name    = "${var.name}-web.${var.route53_zone}"
  type    = "A"

  alias {
    name                   = "${var.hostname}"
    zone_id                = "${var.elb_zone_id}"
    evaluate_target_health = false
  }
}
