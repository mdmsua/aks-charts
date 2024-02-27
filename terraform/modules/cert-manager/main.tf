resource "kubernetes_namespace_v1" "main" {
  metadata {
    name = "cert-manager"
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

resource "helm_release" "main" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = var.cert_manager.version
  namespace        = kubernetes_namespace_v1.main.metadata.0.name
  create_namespace = false
  atomic           = true
  cleanup_on_fail  = true
  reuse_values     = true
  wait             = true

  set {
    name  = "installCRDs"
    value = "true"
  }

  set_list {
    name = "extraArgs"
    value = [
      "--feature-gates=ExperimentalGatewayAPISupport=true"
    ]
  }
}

/* 
resource "kubernetes_manifest" "cluster_issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt-${var.cert_manager.production ? "production" : "staging"}"
    }
    spec = {
      acme = {
        email  = var.cert_manager.email
        server = var.cert_manager.production ? local.letsencrypt.production : local.letsencrypt.staging
        privateKeySecretRef = {
          name = "acme-account-key-${var.cert_manager.production ? "production" : "staging"}"
        }
        solvers = [
          {
            dns01 = {
              cloudflare = {
                apiTokenSecretRef = {
                  name = kubernetes_secret_v1.cloudflare.metadata.0.name
                  key  = local.api_token_key
                }
              }
            }
          }
        ]
      }
    }
  }

  depends_on = [helm_release.main]
}
*/

resource "kubectl_manifest" "cluster_issuer" {
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: "letsencrypt-${var.cert_manager.production ? "production" : "staging"}"
spec:
  acme:
    email: "${var.cert_manager.email}"
    server: "${var.cert_manager.production ? local.letsencrypt.production : local.letsencrypt.staging}"
    privateKeySecretRef:
      name: "acme-account-key-${var.cert_manager.production ? "production" : "staging"}"
    solvers:
    - dns01:
        cloudflare:
          apiTokenSecretRef:
            name: "${kubernetes_secret_v1.cloudflare.metadata.0.name}"
            key: "${local.api_token_key}"
  YAML

  depends_on = [helm_release.main]
}
