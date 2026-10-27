# Find the instance the ASG launched, so CloudFront knows where to send traffic
data "aws_instances" "catapp" {
  instance_tags = {
    "aws:autoscaling:groupName" = aws_autoscaling_group.catapp.name
  }
  instance_state_names = ["running"]
}

data "aws_instance" "catapp" {
  instance_id = data.aws_instances.catapp.ids[0]
}

# AWS's ready-made "don't cache anything" policy — your app shows a random cat
# on every load, so caching would show the same cat to everyone
data "aws_cloudfront_cache_policy" "no_cache" {
  name = "Managed-CachingDisabled"
}

resource "aws_cloudfront_distribution" "catapp" {
  enabled     = true
  price_class = "PriceClass_100" # cheapest: US/Canada/Europe edge locations only

  # Where CloudFront fetches the app from: your instance, over plain HTTP on 8888
  origin {
    origin_id   = "catapp-ec2"
    domain_name = data.aws_instance.catapp.public_dns

    custom_origin_config {
      http_port              = var.host_port
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id       = "catapp-ec2"
    viewer_protocol_policy = "redirect-to-https" # http:// visitors get sent to https://
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    cache_policy_id        = data.aws_cloudfront_cache_policy.no_cache.id
  }

  # Use AWS's own trusted certificate for *.cloudfront.net
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
