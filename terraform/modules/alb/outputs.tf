data "aws_lb" "external" {
  //name = "image-api-alb" # Name of the ALB
  tags = {
    "elbv2.k8s.aws/cluster" = var.cluster_name
  }
  depends_on = [null_resource.apply_ingress]
}

output "alb_dns_name" {
  value = data.aws_lb.external.dns_name
}

output "alb_zone_id" {
  value = data.aws_lb.external.zone_id
}

output "alb_arn" {
  value = data.aws_lb.external.arn
}