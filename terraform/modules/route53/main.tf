resource "aws_route53_zone" "primary" { # Create a Route53 hosted zone
  name = var.domain_name                # Domain name for the hosted zone
}

resource "aws_route53_record" "api" {        # Create a Route53 record for the API
  zone_id = aws_route53_zone.primary.zone_id # Zone ID for the hosted zone
  name    = "api.${var.domain_name}"         # Name of the record
  type    = "A"                              # Type of the record

  alias {
    name                   = var.alb_dns_name # DNS name for the ALB
    zone_id                = var.alb_zone_id  # Zone ID for the ALB
    evaluate_target_health = true             # Evaluate target health
  }
}

resource "aws_route53_record" "grafana" {    # Create a Route53 record for Grafana
  zone_id = aws_route53_zone.primary.zone_id # Zone ID for the hosted zone
  name    = "grafana.${var.domain_name}"     # Name of the record
  type    = "A"                              # Type of the record

  alias {
    name                   = var.alb_dns_name # DNS name for the ALB
    zone_id                = var.alb_zone_id  # Zone ID for the ALB
    evaluate_target_health = true             # Evaluate target health
  }
}
