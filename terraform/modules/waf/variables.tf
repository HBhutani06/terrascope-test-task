variable "name" {
  description = "Name of the WAF ACL"
  type        = string
}

variable "resource_arn" {
  description = "The ARN of the resource to associate (e.g., ALB)"
  type        = string
}

variable "rate_limit" {
  description = "Rate limit (requests per 5 min)"
  type        = number
}
