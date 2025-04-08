resource "kubernetes_namespace" "image_api" {
  metadata {
    name = "image-api"
    labels = {
      environment = var.environment
    }
  }
}
