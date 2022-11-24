variable "bucket_regional_domain_name" {
    description = "Regional name of s3 bucket"
    type = string
}

variable "tlscert_arn" {
    description = "Arn for ACM TLS certificate"
    type = string
}

variable "domain" {
    description = "My domain name"
    type = string
}

variable "subdomain" {
    description = "WWW subdomain"
    type = string
}
