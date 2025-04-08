# Ensure the Monitoring Namespace Exists
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.monitoring_namespace
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}

# Helm release for Prometheus + Grafana
resource "helm_release" "monitoring" {
  name       = var.prometheus_chart_name
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  chart      = var.prometheus_chart_name
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = "51.2.0"

  values = [templatefile("${path.module}/values.yaml", {})]

  depends_on = [kubernetes_namespace.monitoring]
}