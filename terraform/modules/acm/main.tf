resource "aws_acm_certificate" "cert" { # Create ACM certificate
  domain_name       = var.domain_name   # The domain name for the certificate
  validation_method = "DNS"             # The validation method for the certificate
  subject_alternative_names = [
    "*.${var.domain_name}"
  ]
}

resource "aws_route53_record" "validation" { # Create Route 53 DNS records for ACM validation
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  zone_id = var.zone_id        # Get the Route 53 zone ID
  name    = each.value.name    # The name of the DNS record
  type    = each.value.type    # The type of the DNS record
  records = [each.value.value] # The value of the DNS record
  ttl     = 60                 # The time to live for the DNS record
}

resource "aws_acm_certificate_validation" "cert" {                                      # Validate the ACM certificate
  certificate_arn         = aws_acm_certificate.cert.arn                                # The ARN of the ACM certificate
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn] # The fully qualified domain names of the validation records
}
