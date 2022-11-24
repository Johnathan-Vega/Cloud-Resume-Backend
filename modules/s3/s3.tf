resource "aws_s3_bucket" "primarybucket" {
  bucket = var.bucket
}

resource "aws_s3_bucket_acl" "primarybucket_acl" {
  bucket = aws_s3_bucket.primarybucket.id
  acl    = "private"
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.primarybucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [var.cloudfront_oai_iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.primarybucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket                  = aws_s3_bucket.primarybucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}