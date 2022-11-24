output "bucket_regional_domain_name" {
    description = "Regional name of s3 bucket for Cloudfront to reference"
    value = aws_s3_bucket.primarybucket.bucket_regional_domain_name
}