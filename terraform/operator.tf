resource "kubernetes_namespace_v1" "operator" {
  metadata {
    name = "tfc-operator-system"
  }
}

resource "kubernetes_secret_v1" "operator" {
  metadata {
    name      = "tfc-operator"
    namespace = kubernetes_namespace_v1.operator.metadata.0.name
  }
  data = {
    token = var.operator.token
  }
}

resource "helm_release" "operator" {
  name             = "operator"
  repository       = "https://helm.releases.hashicorp.com"
  chart            = "terraform-cloud-operator"
  namespace        = kubernetes_namespace_v1.operator.metadata.0.name
  create_namespace = false
  atomic           = true
  cleanup_on_fail  = true
  reuse_values     = true
  wait             = true
}
