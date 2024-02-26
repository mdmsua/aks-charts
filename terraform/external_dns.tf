resource "kubernetes_namespace_v1" "external_dns" {
  metadata {
    name = "external-dns"
  }
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

  set_sensitive {
    name  = "env.CF_API_TOKEN"
    value = var.spec.secrets.cloudflare_api_token
  }

  set_list {
    name = "args"
    value = [
      "--provider=cloudflare",
      "--source=gateway-httproute",
      "--source=gateway-tlsroute",
      "--source=gateway-tcproute",
      "--source=gateway-udproute",
      "--source=gateway-grpcroute",
    ]
  }
}
