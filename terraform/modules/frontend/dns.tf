resource "aws_route53_zone" "this" {
  name = var.website_name
}

resource "aws_route53_record" "validation_records" {
  for_each = {
    for dvo in aws_acm_certificate.ssl_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 300
  zone_id = aws_route53_zone.this.zone_id
}

resource "aws_route53_record" "a_records" {
  for_each   = toset(["www.${var.website_name}", var.website_name])
  depends_on = [aws_acm_certificate.ssl_cert, aws_cloudfront_distribution.s3_dist]

  name    = each.value
  type    = "A"
  zone_id = aws_route53_zone.this.zone_id

  alias {
    name    = aws_cloudfront_distribution.s3_dist.domain_name
    zone_id = aws_cloudfront_distribution.s3_dist.hosted_zone_id

    evaluate_target_health = true
  }
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

resource "aws_acm_certificate" "ssl_cert" {
  provider          = aws.us_east_1
  domain_name       = var.website_name
  validation_method = "DNS"

  subject_alternative_names = [
    "www.${var.website_name}"
  ]
}

resource "aws_acm_certificate_validation" "ssl_validation" {
  depends_on = [aws_acm_certificate.ssl_cert, aws_route53_record.validation_records]

  provider        = aws.us_east_1
  certificate_arn = aws_acm_certificate.ssl_cert.arn

  validation_record_fqdns = [for record in aws_route53_record.validation_records : record.fqdn]
}


# TODO import ssl validations and route 53 related stuff so i don't have to wait an hour+ every time i destroy and re-create the infrastructure
