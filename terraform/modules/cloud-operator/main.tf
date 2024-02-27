resource "kubernetes_namespace_v1" "main" {
  metadata {
    name = "tfc-operator-system"
  }
}

resource "kubernetes_secret_v1" "main" {
  metadata {
    name      = "tfc-operator"
    namespace = kubernetes_namespace_v1.main.metadata.0.name
  }

  data = {
    token = var.terraform_api_token
  }
}

resource "helm_release" "main" {
  name             = "cloud-operator"
  repository       = "https://helm.releases.hashicorp.com"
  chart            = "terraform-cloud-operator"
  version          = var.cloud_operator.version
  namespace        = kubernetes_namespace_v1.main.metadata.0.name
  create_namespace = false
  atomic           = true
  cleanup_on_fail  = true
  reuse_values     = true
  wait             = true
}
