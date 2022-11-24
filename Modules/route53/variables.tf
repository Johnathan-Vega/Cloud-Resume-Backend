variable "cloudfront_domain_name" {
    description = "Cloudfront distribution domain name for Route 53 to use in alias"
    type = string
}

variable "cloudfront_hosted_zone_id" {
    description = "Cloudfront distribution hosted zone id associated with Route 53"
    type = string
}

variable "domain" {
    description = "My domain name"
    type = string
}

variable "subdomain" {
    description = "WWW subdomain"
    type = string
    default = "www.johnathanvega.com"
}