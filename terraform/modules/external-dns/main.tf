resource "kubernetes_namespace_v1" "main" {
  metadata {
    name = "external-dns"
  }
}

resource "kubernetes_secret_v1" "cloudflare" {
  metadata {
    name      = "cloudflare"
    namespace = kubernetes_namespace_v1.main.metadata.0.name
  }
  data = {
    "${local.api_token_key}" = var.cloudflare_api_token
  }
}

resource "helm_release" "external_dns" {
  name             = "external-dns"
  repository       = "https://kubernetes-sigs.github.io/external-dns"
  chart            = "external-dns"
  version          = var.external_dns.version
  namespace        = kubernetes_namespace_v1.main.metadata.0.name
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
}
