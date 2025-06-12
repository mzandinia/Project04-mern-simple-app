# ECR outputs
output "repository_url" {
  description = "URL of the ECR repository"
  value       = module.ecr.repository_url
}

output "cluster_endpoint" {
  description = "The connection endpoint for the DocumentDB cluster"
  value       = module.docdb.cluster_endpoint
}

# CloudFront outputs
output "cloudfront_distribution_domain" {
  description = "The domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.frontend_distribution.domain_name
}

output "cloudfront_distribution_id" {
  description = "The ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.frontend_distribution.id
}

output "frontend_bucket_name" {
  description = "The name of the S3 bucket hosting the frontend"
  value       = aws_s3_bucket.frontend_bucket.id
}

output "frontend_url" {
  description = "The URL to access the frontend application"
  value       = "https://${aws_cloudfront_distribution.frontend_distribution.domain_name}"
}

output "alb_arn" {
  description = "ARN of the ALB"
  value       = module.alb.alb_arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}