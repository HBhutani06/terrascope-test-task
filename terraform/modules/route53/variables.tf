variable "domain_name" {
  description = "The root domain name to create hosted zone for"
  type        = string
}

variable "alb_dns_name" {
  description = "ALB DNS name"
  type        = string
}

variable "alb_zone_id" {
  description = "ALB Zone ID"
  type        = string
}
