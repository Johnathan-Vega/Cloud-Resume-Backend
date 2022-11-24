variable "bucket" {
    description = "Name of bucket"
    type = string
}

variable "cloudfront_oai_iam_arn" {
    description = "Full iam arn to use inside S3 policy"
    type = string
}