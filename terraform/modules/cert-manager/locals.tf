locals {
  letsencrypt = {
    staging    = "https://acme-staging-v02.api.letsencrypt.org/directory"
    production = "https://acme-v02.api.letsencrypt.org/directory"
  }
  crds_url      = "https://github.com/cert-manager/cert-manager/releases/download/${var.cert_manager.version}/cert-manager.crds.yaml"
  crds          = { for yaml in split("---", data.http.crds.response_body) : yamldecode(yaml).metadata.name => yaml }
  api_token_key = "api-token"
}
