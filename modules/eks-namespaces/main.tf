resource "kubernetes_namespace" "k8s_namespace" {
  for_each = toset(var.namespaces)
  metadata {
    name = each.key
  }
}

