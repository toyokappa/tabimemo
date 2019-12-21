resource "aws_cloudfront_distribution" "main" {
  enabled = true
  is_ipv6_enabled = true
  comment = "${local.app_name}-${terraform.workspace}-distribution"
  default_root_object = ""
  
  #-----------------------------------------------------------
  # web
  origin {
    domain_name = aws_lb.alb.dns_name
    origin_id = aws_lb.alb.id

    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      origin_protocol_policy = "match-viewer"
    }
  }

  default_cache_behavior {
    allowed_methods = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
    cached_methods = ["HEAD", "GET"]
    target_origin_id = aws_lb.alb.id
    compress = true

    forwarded_values {
      query_string = true
      headers = ["*"]

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "rediect-to-https"
    min_ttl = 0
    default_ttl = 0
    max_ttl = 0
  }

  #-----------------------------------------------------------
  # assets bucket
  origin {
    domain_name = aws_s3_bucket.assets.bucket_domain_name
    origin_id = aws_s3_bucket.assets.id

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/${aws_cloudfront_origin_access_identity.assets.id}"
    }
  }

  ordered_cache_behavior {
    path_pattern = "/assets/*"
    allowed_methods = ["HEAD", "GET", "OPTIONS"]
    cached_methods = ["HEAD", "GET"]
    target_origin_id = aws_s3_bucket.assets.id
    compress = true

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "rediect-to-https"
    min_ttl = 0
    default_ttl = 0
    max_ttl = 0
  }

  #-----------------------------------------------------------
  # resources bucket
  origin {
    domain_name = aws_s3_bucket.resources.bucket_domain_name
    origin_id = aws_s3_bucket.resources.id

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/${aws_cloudfront_origin_access_identity.resources.id}"
    }
  }

  origin {
    domain_name = aws_s3_bucket.resources.bucket_domain_name
    origin_id = aws_s3_bucket.resources.id
  }

  ordered_cache_behavior {
    path_pattern = "/resources/*"
    allowed_methods = ["HEAD", "GET", "OPTIONS"]
    cached_methods = ["HEAD", "GET"]
    target_origin_id = aws_s3_bucket.resources.id
    compress = true

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "rediect-to-https"
    min_ttl = 0
    default_ttl = 0
    max_ttl = 0
  }

  viewer_certificate {
    cloudfront_default_certificate = true

    # acm_certificate_arn      = ""
    # ssl_support_method       = "sni-only"
    # minimum_protocol_version = "TLSv1.2_2018"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

resource "aws_cloudfront_origin_access_identity" "assets" {
  comment = "${local.app_name}-${terraform.workspace}-assets"
}

resource "aws_cloudfront_origin_access_identity" "resources" {
  comment = "${local.app_name}-${terraform.workspace}-resources"
}
