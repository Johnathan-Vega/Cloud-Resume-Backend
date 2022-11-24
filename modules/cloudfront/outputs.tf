output "cloudfront_oai_iam_arn" {
    description = "Origin Access Identity iam arn for S3 bucket policy"
    value = aws_cloudfront_origin_access_identity.oai.iam_arn
}

output "cloudfront_domain_name" {
    description = "Cloudfront distribution domain name for Route 53 to use in alias"
    value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "cloudfront_hosted_zone_id" {
    description = "Cloudfront distribution hosted zone id associated with Route 53"
    value = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
}



