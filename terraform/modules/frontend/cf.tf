locals {
	s3_origin_id = "website-origin"
	api_origin_id = "api-origin"
}

data "aws_cloudfront_cache_policy" "caching_disabled" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_origin_request_policy" "all_viewer_except_host_header" {
  name = "Managed-AllViewerExceptHostHeader"
}

resource "aws_cloudfront_distribution" "s3_dist" {
	depends_on = [ aws_acm_certificate_validation.ssl_validation ]

	# S3 origin
	origin {
    domain_name              = aws_s3_bucket.this.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id
    origin_id                = local.s3_origin_id
  }

	# api origin
	origin {
		domain_name = var.api.invoke_url
		origin_id 	= local.api_origin_id
		origin_path = "/${var.api.name}"
	}

  enabled             = true
  default_root_object = "index.html"

  aliases = [var.website_name, "www.${var.website_name}"]

	ordered_cache_behavior {
		allowed_methods  	= ["GET", "HEAD", "POST"]
    cached_methods   	= ["GET", "HEAD"]
		path_pattern 			= "/api/*"
		target_origin_id 	= local.api_origin_id

		cache_policy_id 					= data.aws_cloudfront_cache_policy.caching_disabled.id
		origin_request_policy_id 	= data.aws_cloudfront_origin_request_policy.all_viewer_except_host_header.id

		function_association {
			event_type   = "viewer-request"
			function_arn = aws_cloudfront_function.modify_api_origin_func.arn
		}

		viewer_protocol_policy = "redirect-to-https"
	}

  default_cache_behavior {
    allowed_methods  	= ["GET", "HEAD", "POST"]
    cached_methods   	= ["GET", "HEAD"]
    target_origin_id 	= local.s3_origin_id

    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.ssl_cert.arn
    ssl_support_method  = "sni-only"
  }
}

resource "aws_cloudfront_origin_access_control" "s3_oac" {
	name                              = "s3-origin-access-control"
	origin_access_control_origin_type = "s3"
	signing_behavior                  = "always"
	signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_function" "modify_api_origin_func" {
	name 		= "modify-api-origin"
	runtime = "cloudfront-js-2.0"
	code 		= file("${path.module}/cf-func/modify_api_origin.js")
}

output "cf_domain" {
	value = aws_cloudfront_distribution.s3_dist.domain_name
}