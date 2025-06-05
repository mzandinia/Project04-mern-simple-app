# resource "aws_cloudfront_origin_access_identity" "frontend_oai" {
#   comment = "OAI for frontend bucket access"
# }

# resource "aws_s3_bucket" "frontend_bucket" {
#   bucket = "sample-frontend-bucket"
# }

# resource "aws_s3_bucket_public_access_block" "frontend_bucket" {
#   bucket = aws_s3_bucket.frontend_bucket.id

#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }

# resource "aws_s3_bucket_policy" "frontend_bucket_policy" {
#   bucket = aws_s3_bucket.frontend_bucket.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "AllowCloudFrontOAI"
#         Effect = "Allow"
#         Principal = {
#           AWS = aws_cloudfront_origin_access_identity.frontend_oai.iam_arn
#         }
#         Action   = "s3:GetObject"
#         Resource = ["${aws_s3_bucket.frontend_bucket.arn}/*"]
#       }
#     ]
#   })
# }

# resource "aws_s3_bucket_cors_configuration" "frontend_bucket" {
#   bucket = aws_s3_bucket.frontend_bucket.id

#   cors_rule {
#     allowed_headers = ["*"]
#     allowed_methods = ["GET", "HEAD"]
#     allowed_origins = [
#       "https://${aws_cloudfront_distribution.frontend_distribution.domain_name}",
#       aws_apprunner_service.backend.service_url
#     ]
#     expose_headers  = ["ETag"]
#     max_age_seconds = 3600
#   }
# }

# resource "aws_cloudfront_distribution" "frontend_distribution" {
#   origin {
#     domain_name = aws_s3_bucket.frontend_bucket.bucket_regional_domain_name
#     origin_id   = "S3-Frontend-Bucket"

#     s3_origin_config {
#       origin_access_identity = aws_cloudfront_origin_access_identity.frontend_oai.cloudfront_access_identity_path
#     }
#   }

#   enabled             = true
#   is_ipv6_enabled     = true
#   default_root_object = "index.html"

#   custom_error_response {
#     error_code            = 403
#     response_code         = 200
#     response_page_path    = "/error.html"
#     error_caching_min_ttl = 10
#   }

#   custom_error_response {
#     error_code            = 404
#     response_code         = 200
#     response_page_path    = "/error.html"
#     error_caching_min_ttl = 10
#   }

#   default_cache_behavior {
#     allowed_methods  = ["GET", "HEAD", "OPTIONS"]
#     cached_methods   = ["GET", "HEAD"]
#     target_origin_id = "S3-Frontend-Bucket"

#     forwarded_values {
#       query_string = false
#       cookies {
#         forward = "none"
#       }
#     }

#     viewer_protocol_policy = "redirect-to-https"
#     min_ttl                = 0
#     default_ttl            = 3600
#     max_ttl                = 86400
#   }

#   price_class = "PriceClass_100"

#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }

#   viewer_certificate {
#     cloudfront_default_certificate = true
#   }
# }
