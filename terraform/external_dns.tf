resource "kubernetes_namespace_v1" "external_dns" {
  metadata {
    name = "external-dns"
  }

  depends_on = [helm_release.cilium]
}

locals {
  api_token_key = "api-token"
}

resource "kubernetes_secret_v1" "cloudflare" {
  metadata {
    name      = "cloudflare"
    namespace = kubernetes_namespace_v1.external_dns.metadata.0.name
  }
  data = {
    "${local.api_token_key}" = var.secrets.cloudflare_api_token
  }

  depends_on = [helm_release.cilium]
}


resource "helm_release" "external_dns" {
  name             = "external-dns"
  repository       = "https://kubernetes-sigs.github.io/external-dns"
  chart            = "external-dns"
  version          = "v${var.spec.charts.external_dns.version}"
  namespace        = kubernetes_namespace_v1.external_dns.metadata.0.name
  create_namespace = false
  atomic           = true
  cleanup_on_fail  = true
  reuse_values     = true
  wait             = true

  values = [
    templatefile("${path.module}/files/external-dns.yaml", {
      secret_name = kubernetes_secret_v1.cloudflare.metadata.0.name,
      secret_key  = local.api_token_key
    })
  ]

  depends_on = [helm_release.cilium]
}
