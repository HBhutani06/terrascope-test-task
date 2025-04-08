resource "aws_wafv2_web_acl" "waf_acl" { # Create a WAF Web ACL
  name        = var.name                 # Name of the WAF ACL
  scope       = "REGIONAL"               # For ALB
  description = "WAF for ALB with rate limiting"

  default_action { # Default action for requests not matching any rules
    allow {}
  }

  visibility_config {                                  # Configuration for visibility metrics
    cloudwatch_metrics_enabled = true                  # Enable CloudWatch metrics
    metric_name                = "${var.name}-metrics" # Metric name
    sampled_requests_enabled   = true                  # Enable sampled requests
  }

  rule {
    name     = "RateLimitRule" # Name of the rate limit rule
    priority = 1               # Priority of the rule (lower number = higher priority)

    action {
      block {} # Action to take when the rate limit is exceeded
    }

    statement {
      rate_based_statement {                # Rate-based statement for rate limiting
        limit              = var.rate_limit # Rate limit (requests per 5 min)
        aggregate_key_type = "IP"           # Aggregate key type (IP address)
      }
    }

    visibility_config {                            # Configuration for visibility metrics
      cloudwatch_metrics_enabled = true            # Enable CloudWatch metrics
      metric_name                = "RateLimitRule" # Metric name
      sampled_requests_enabled   = true            # Enable sampled requests
    }
  }
}

resource "aws_wafv2_web_acl_association" "waf_acl_assoc" { # Associate the WAF ACL with a resource (e.g., ALB)
  resource_arn = var.resource_arn                          # ARN of the resource to associate
  web_acl_arn  = aws_wafv2_web_acl.waf_acl.arn             # ARN of the WAF ACL
}
