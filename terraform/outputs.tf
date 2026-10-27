# Where to push images
output "repository_url" {
  description = "ECR repository URL to tag and push the app image to"
  value       = aws_ecr_repository.catapp.repository_url
}

# Where to visit the app
output "https_url" {
  description = "HTTPS address of the app, served through CloudFront"
  value       = "https://${aws_cloudfront_distribution.catapp.domain_name}"
}

# Network lookups, handy for checking against the console
output "vpc_id" {
  description = "Default VPC the app runs in"
  value       = data.aws_vpc.default.id
}

output "subnet_id" {
  description = "Subnet the instance runs in (us-east-1a)"
  value       = data.aws_subnet.a.id
}
